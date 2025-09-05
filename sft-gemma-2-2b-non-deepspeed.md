# ========== モデル ==========
base_model: google/gemma-2-2b
model_type: AutoModelForCausalLM
tokenizer_type: AutoTokenizer
padding_side: right  # 右パディング推奨（FA2/packing整合）

# ========== Hub ==========
hub_model_id: ikedachin/gemma-2-2b-axolotl-sft-nonDeepSpeed-v1.0
hub_strategy: "end"
# push_dataset_to_hub:  # ← 不要なので削除
hf_use_auth_token: true  # 環境変数 HF_TOKEN 推奨（互換のため残置可）

# ========== 量子化 / QLoRA ==========
load_in_8bit: false
load_in_4bit: true
adapter: qlora
lora_model_dir:
lora_r: 16
lora_alpha: 32
lora_dropout: 0.05
lora_target_linear: true
lora_fan_in_fan_out:

# bitsandbytes 推奨設定（必須級）
bnb_4bit_use_double_quant: true
bnb_4bit_quant_type: nf4
bnb_4bit_compute_dtype: bfloat16

# ========== Liger（まずはオフでベースライン） ==========
plugins:
  # - axolotl.integrations.liger.LigerPlugin  # まず無効化
liger_cross_entropy: false
liger_rope: false
liger_rms_norm: false
liger_swiglu: false
liger_fused_linear_cross_entropy: false

# ========== データセット（tokenizer の chat_template に委譲） ==========
datasets:
  - path: kanhatakeyama/ramdom-to-fixed-multiturn-Calm3
    split: 20240806filtered[0:100]
    type: chat
    field_messages: messages
    message_field_role: role
    message_field_content: content
  - path: llm-jp/magpie-sft-v1.0
    split: train[0:100]
    type: chat
    field_messages: conversations
    message_field_role: role
    message_field_content: content
  - path: Aratako/magpie-qwen2.5-32b-reasoning-100k-formatted
    split: train[0:100]
    type: chat
    field_messages: conversations
    message_field_role: role
    message_field_content: content

shuffle_merged_datasets: true
dataset_prepared_path: /workspace/data/sft-data
output_dir: /workspace/data/models/gemma-2-2b-axolotl-sft-v1.0

# ========== 検証 ==========
val_set_size: 0.05

# ========== 学習基本設定 ==========
sequence_len: 4096
sample_packing: true
eval_sample_packing: false
pad_to_sequence_len: true

micro_batch_size: 1
gradient_accumulation_steps: 16
num_epochs: 1

optimizer: paged_adamw_8bit
weight_decay: 0.01
learning_rate: 1.5e-4           # ← 3e-4 → 1.5e-4 に下げる
lr_scheduler: cosine
cosine_min_lr_ratio: 0.1
warmup_steps: 10

train_on_inputs: false
group_by_length: false

bf16: auto
fp16:
tf32: true                     # Hopper で throughput 改善

gradient_checkpointing: true   # メモリ削減＆長尺安定化

# ========== ログ ==========
wandb_project: axolotl
wandb_entity: ikedachin
wandb_watch:
wandb_name: nondeepseed-sft-lora-1
wandb_log_model:

logging_steps: 1

# ========== アテンション / 実装 ==========
xformers_attention:
flash_attention: true

# ========== セーブ / 評価 ==========
save_strategy: steps
save_steps: 50
save_total_limit: 2

eval_steps: 50
eval_batch_size: 1
eval_table_size:
eval_max_new_tokens:
debug:

# ========== 並列系 ==========
deepspeed:         # ← QLoRA では外す（ゼロ化）
fsdp:
fsdp_config:
early_stopping_patience:
auto_resume_from_checkpoints: true
local_rank:

# ========== special_tokens ==========
# 追加しない（pad_token は eos を使う運用。語彙衝突を避ける）
# special_tokens:
#   pad_token: <pad>

