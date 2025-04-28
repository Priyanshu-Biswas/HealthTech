import spacy

nlp=spacy.load("en_core_web_sm")

def preprocess_text(text):
   
    doc = nlp(text)
    return doc

def extract_entities(doc):
   
    entities = [(ent.text, ent.label_) for ent in doc.ents]
    return entities

def identify_intent(doc):
    if any(token.lemma_ == "Cardiac" in [t.lemma_ for t in doc] for token in doc):
        return "cardiac"
    elif any(token.lemma_ == "Respiratory"  in [t.lemma_ for t in doc] for token in doc):
        return "respiratory"
    elif any(token.lemma_ =="Gastrointestinal" in [t.lemma_ for t in doc] for token in doc):
        return "gastrointestinal"
    elif any(token.lemma_ =="Cardiac" and "Respiratory" in [t.lemma_ for t in doc] for token in doc):
        return "cardiac_respiratory"
    elif any(token.lemma_ =="Cardiac" and "Gastrointestinal" in [t.lemma_ for t in doc] for token in doc):
        return "cardiac_gastrointestinal"
    elif any(token.lemma_ =="Respiratory" and "Gastrointestinal" in [t.lemma_ for t in doc] for token in doc):
        return "respiratory_gastrointestinal"
    else:
        return "unknown"
    


def process_command(command):
    
    doc = preprocess_text(command)
    intent = identify_intent(doc)
    entities = extract_entities(doc)
    return intent, entities