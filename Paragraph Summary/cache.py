import transformers
from summarizer import Summarizer

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