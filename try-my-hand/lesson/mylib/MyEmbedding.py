from langchain_huggingface import HuggingFaceEmbeddings

class MyEmbedding:
    @staticmethod
    def get_model(model_name = "intfloat/multilingual-e5-large"):
        model = HuggingFaceEmbeddings(model_name = model_name)
        return model
