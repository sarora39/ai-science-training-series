import os
import numpy as np
import torch
import transformers
from groqflow import groqit

from demo_helpers.compute_performance import compute_performance
from demo_helpers.args import parse_args

import argparse

def get_model():
    pretrained_model_name = "M-FAC/bert-tiny-finetuned-sst2"
    tokenizer = transformers.AutoTokenizer.from_pretrained(pretrained_model_name)
    pytorch_model = transformers.AutoModelForSequenceClassification.from_pretrained(
        pretrained_model_name, torchscript=True
    )

    return pytorch_model.eval(), tokenizer


def evaluate_bert_tiny(batch_size, max_seq_length, rebuild_policy=None, should_execute=True):
    np.random.seed(1)
    torch.manual_seed(0)
    os.environ["TOKENIZERS_PARALLELISM"] = "false"

    pytorch_model, tokenizer = get_model()

    custom_inputs = {"input_ids": torch.ones(1, max_seq_length, dtype=torch.long), "attention_mask": torch.ones(1, max_seq_length, dtype=torch.bool)}
    # Model built to always take input of shape {'attention_mask': (batch_size, 128), 'input_ids': (batch_size, 128)} but got {'attention_mask': (1, 128), 'input_ids': (1, 128)}

    groq_model = groqit(pytorch_model, custom_inputs, rebuild=rebuild_policy)

    if should_execute:
        compute_performance(
            groq_model,
            pytorch_model,
            dataset="sst",
            tokenizer=tokenizer,
            max_seq_length=max_seq_length
            task="classification"
        )

    print(f"Proof point {__file__} finished!")

def parse_args():
    parser = argparse.ArgumentParser(description="Evaluate BERT-tiny model with custom inputs")
    parser.add_argument("--batch_size", type=int, default=1, help="Batch size for inference (default: 1)")
    parser.add_argument("--max_seq_length", type=int, default=128, help="Maximum sequence length (default: 128)")
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    evaluate_bert_tiny(args.batch_size, args.max_seq_length)
