from langchain_milvus import Milvus
from pymilvus import MilvusClient
from mylib.MyCustomRetriever import MyCustomRetriever

class MyMilvus:

    def __init__(self, host, port, user, password, embeddings):
        self.connection_args = self.__get_connect_args(
            host, port, user, password)
        self.embeddings = embeddings
        db_name = "default"
        self.client = MilvusClient(
            uri = "http://%s:%d" % (host, port),
            token = "%s:%s" % (user, password),
            db_name = db_name)

    def get_connection_args(self):
        return self.connection_args

    def get_collections(self):
        collections = self.client.list_collections()
        return collections

    # connect to the collection
    def connect(self, collection_name):
        collection = Milvus(
            self.embeddings,
            connection_args = self.connection_args,
            collection_name = collection_name
        )
        return collection

    def from_documents(self, docs, collection_name):
        index_params = self.__get_index_params()
        collection = Milvus.from_documents(
            docs,
            self.embeddings,
            connection_args = self.connection_args,
            collection_name = collection_name,
            index_params = index_params,
            drop_old = True, # If adding data, you should set False here.
        )
        return collection

    def get_retriever(self, collection, k = None, score = None):
        if (k is None):
            retriever = collection.as_retriever()
        else:
            if (score is None):
                retriever = collection.as_retriever(search_kwargs={"k": k})
            else:
#                retriever = collection.as_retriever(
#                    search_type="similarity_score_threshold",
#                    search_kwargs={"k": k, "score_threshold": score})
                retriever = MyCustomRetriever(
                    vectorstore = collection,
                    search_kwargs={"k": k, "score_threshold": score})
        return retriever

    def __get_connect_args(self, host, port, user, password):
        args ={
            'uri': "http://%s:%d" % (host, port),
            'token': "%s:%s" % (user, password)
        }
        return args

    def __get_index_params(self):
        params = {
            "metric_type": "COSINE", # Cosine Similarity
            "index_type": "HNSW", 
            "params": { "M": 16, "efConstruction": 200, "efSearch": 16}
        }
        return params
