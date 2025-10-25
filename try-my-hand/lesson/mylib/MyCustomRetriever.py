from langchain_core.vectorstores import VectorStoreRetriever
from langchain_core.callbacks.manager import (CallbackManagerForRetrieverRun)
from typing import List
from langchain_core.documents import Document

class MyCustomRetriever(VectorStoreRetriever):
    def _get_relevant_documents(
        self, query: str, *,
        run_manager: CallbackManagerForRetrieverRun) -> List[Document]:
        top_k = self.search_kwargs.get("k", 4)
        docs_and_similarities = self.vectorstore.similarity_search_with_score(query, k=top_k)      
        threshold = self.search_kwargs.get("score_threshold", 0)
        return [doc for doc, score in docs_and_similarities if score >= threshold and score <= 1]

