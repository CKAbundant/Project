import warnings
warnings.simplefilter(action="ignore", category=FutureWarning)
import torch
import transformers
import streamlit as st
import time
from summarizer import Summarizer

DEFAULT_TEXT_INPUT = "饮料也不例外。市场上很多饮料都是含糖的，包括碳酸饮料、茶饮料等。敏锐的食品生产商将目标对准了饮料市场，开始生产无糖饮料、代糖饮料。\
这些饮料里都含有人造甜味剂。这些人造甜味剂虽然不是糖，但是却能够产生甜味，让人的大脑感觉甜，被很多人认为是糖的健康替代品。不但能少吃糖，减少糖带来的健康风险，\
又能满足我们的味觉享受。但这些人造甜味剂真的更健康吗？"



@st.cache(allow_output_mutation=True)
def load_trans_models(translate_lang: str) -> object:
    """Load models for Translation (Chinese to English or Japanese to English) and Summarization (Extractive or Abstractive)"""
    
    if translate_lang == "Chinese":
        # Chinese to English
        ZH_EN_MODEL = "Helsinki-NLP/opus-mt-zh-en"
        zh_en_tokenizer = transformers.AutoTokenizer.from_pretrained(ZH_EN_MODEL)
        zh_en_model = transformers.AutoModelForSeq2SeqLM.from_pretrained(ZH_EN_MODEL)
        tr_model = transformers.pipeline("text2text-generation", model=zh_en_model, tokenizer=zh_en_tokenizer, device=0)
    
    elif translate_lang == "Japanese":
        # Japanese to English
        JA_EN_MODEL = "staka/fugumt-ja-en"
        ja_en_tokenizer = transformers.AutoTokenizer.from_pretrained(JA_EN_MODEL)
        ja_en_model = transformers.AutoModelForSeq2SeqLM.from_pretrained(JA_EN_MODEL)
        tr_model = transformers.pipeline("text2text-generation", model=ja_en_model, tokenizer=ja_en_tokenizer, device=0)
    
    return tr_model



def translator(translator_model: object, input_text:str) -> str:
    """Translate input text using pre-trained model"""
    
    input_text = input_text.strip()
    if len(input_text) > 0:
        transation = translator_model(input_text)[0]["generated_text"]
        return transation.strip()
    else:
        return ""



@st.cache(allow_output_mutation=True)    
def load_summary_models(summary_type:str) -> object:
    """Perform extractive or abstractive summary"""
    
    if summary_type == "Extractive":
        # Extractive summary
        EXT_MODEL = "distilroberta-base"
        custom_config = transformers.AutoConfig.from_pretrained(EXT_MODEL)
        custom_config.output_hidden_states=True
        custom_tokenizer = transformers.AutoTokenizer.from_pretrained(EXT_MODEL)
        custom_model = transformers.AutoModel.from_pretrained(EXT_MODEL, config=custom_config)
        sum_model = Summarizer(custom_model=custom_model, custom_tokenizer=custom_tokenizer)
        
    elif summary_type == "Abstractive":
        # Abstractive summary
        AB_MODEL = "google/pegasus-xsum"
        sm_tokenizer = transformers.AutoTokenizer.from_pretrained(AB_MODEL)
        sm_model = transformers.AutoModelForSeq2SeqLM.from_pretrained(AB_MODEL)
        sum_model = transformers.pipeline("summarization", model=sm_model, tokenizer=sm_tokenizer, device=0)
        
    return sum_model



# Side-bar Layout
st.sidebar.image("nvidia.png", use_column_width='auto')
translate_lang = st.sidebar.selectbox("Language to be translated to English", ["Chinese", "Japanese"])
summary_style = st.sidebar.selectbox("Extractive or Abstractive Summary", ["Extractive", "Abstractive"])
len_words = st.sidebar.slider("Length of Abstractive Summary", min_value=10, max_value=50, value=20, step=1)

# Main layout    
st.title("Paragraph Summary")
st.markdown("Summary of Japanese or Chinese paragraph after being translated to English")
input_text = st.text_area("Input text", value=DEFAULT_TEXT_INPUT, height=150)

# Capture time to translate paragraph
start_time = time.time()
translator_model = load_trans_models(translate_lang)
translation = translator(translator_model, input_text)
end_time = time.time()
time_taken = str(round(end_time-start_time,2))

# Output translated text and time taken to translate
st.text_area("Translated Text: ", value=translation, height=150)
st.markdown("Time taken: "+str(time_taken)+"s")

# Capture time to summarize paragraph
start_time = time.time()
summary_model = load_summary_models(summary_style)

if summary_style == "Extractive":
    summary = summary_model(translation)
elif summary_style == "Abstractive":
    summary = summary_model(translation, max_length=len_words)[0]["summary_text"]

end_time = time.time()
time_taken = str(round(end_time-start_time,2))

# Output summary text and time taken to summarize
st.text_area("Summary Text: ", value=summary, height=100)
st.markdown("Time taken: "+str(time_taken)+"s")