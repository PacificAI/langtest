---
layout: docs
header: true
seotitle: LangTest - Deliver Safe and Effective Language Models | John Snow Labs
title: LangTest Release Notes
permalink: /docs/pages/docs/langtest_versions/latest_release
key: docs-release-notes
modify_date: 2024-12-02
---

<div class="h3-box" markdown="1">

## 2.7.0
------------------
### 📢 Highlights

We’re thrilled to announce the latest LangTest release, bringing advanced benchmarks, new robustness testing, and improved developer experience to your model evaluation workflows.

- **🩺 Autonomous Medical Evaluation for Guideline Adherence (AMEGA):**  
We’ve integrated AMEGA, a comprehensive benchmark for assessing LLM adherence to clinical guidelines. Covering 20 diagnostic scenarios across 13 specialties. The benchmark includes 135 questions and 1,337 weighted scoring elements, providing one of the most rigorous frameworks for evaluating medical knowledge in real-world clinical settings.

- **🧪 MedFuzz Robustness Testing:**  
 To better reflect real-world clinical complexities, we're introducing MedFuzz, a healthcare-specific robustness approach that probes LLMs beyond standard benchmarks

- **🎲 Randomized Options in QA Tasks:**  
  Introducing a new robustness test to mitigate positional bias in multiple-choice evaluations, LangTest now supports the randomized option ordering test type in the robustness category.

- **📝 ACI-Bench: Ambient Clinical Intelligence Benchmark:**  
 LangTest now supports evaluation with ACI-Bench, a novel benchmark for automatic visit note generation in clinical contexts

- **💬 MTS-Dialog: Clinical Summary Evaluation:**
We’ve added support for the MTS-Dialog dataset to evaluate models on dialogue-to-summary generation and to support sectioned summaries (headers + contents) for more structured evaluation

- **🧠 MentalChat16K Clinical Evaluation Support:**  
LangTest now supports the **MentalChat16K dataset**, enabling evaluation of LLMs in mental health–focused conversational contexts. 

- **🔒Security Enhancements:**  
  Critical vulnerabilities and security issues have been addressed, reinforcing the LangTest's overall stability and safety.

## 🔥 Key Enhancements  

### 🩺 Autonomous Medical Evaluation for Guideline Adherence (AMEGA)  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Pacific-AI-Corp/langtest/blob/main/demo/tutorials/llm_notebooks/AMEGA.ipynb)

We’ve integrated **AMEGA**, a rigorous benchmark for assessing LLM adherence to clinical guidelines. This benchmark spans 20 diagnostic scenarios across 13 specialties, comprising 135 questions and 1,337 weighted scoring elements.  

**Key Features:**  
- Provides a comprehensive evaluation of guideline adherence in real-world medical contexts.  
- Covers diverse specialties to ensure broad applicability.  
- Weighted scoring delivers nuanced insights into model performance.  

**How it works:**
```python
#Import Harness from the LangTest library
from langtest import Harness
import os

os.environ["OPENAI_API_KEY"] = "<YOUR_API_KEY>"
```

Harness setup:

```python
harness = Harness(
    task="question-answering",
    model={
        "model": "gpt-4o-mini",
        "hub": "openai",
        "type": "chat"
    },
    data=[],
    config={
        "tests": {
            "defaults": {
                "min_pass_rate": 0.8
            },
            "clinical": {
                "amega" : {
                    "no_of_cases": 5, # upto 20 cases
                }
            }
        }
    }
)
```
execution:
```python
harness.generate().run().report()
```
<img width="956" height="202" alt="image" src="https://github.com/user-attachments/assets/33d5f6ff-3d53-4f0f-8c79-ff371d4e8250" />


---

### 🧪 MedFuzz Robustness Testing  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Pacific-AI-Corp/langtest/blob/main/demo/tutorials/llm_notebooks/MedFuzz_Test.ipynb)

Introducing MedFuzz, a healthcare-specific fuzz testing approach built to stress-test LLMs against clinical complexity beyond conventional benchmarks.

**Key Features:**  
- Generates unexpected input variations to test model robustness.  
- Simulates real-world irregularities in clinical data.  
- Helps identify hidden weaknesses in model reasoning and response patterns.  

**How it works:**
```python
#Import Harness from the LangTest library
from langtest import Harness
import os

os.environ["OPENAI_API_KEY"] = "<YOUR_API_KEY>"
```

Harness setup:

Prompt:
```python
prompt = """
Step 1: Read the question very carefully.
Step 2: Review all four options labeled A, B, C, and D.
Step 3: Identify the single best correct answer.
Step 4: Reply only with the letter A, B, C, or D (no extra text).

Example:
Question:
Which planet is known as the Red Planet?
Options:
A. Earth
B. Venus
C. Mars
D. Jupiter
Answer:
C

Now answer the following:
Question:
{question}
Answer:
"""
```
Harness Config:
```python
from langtest.types import HarnessConfig

config : HarnessConfig = {
    "model_parameters": {
        "user_prompt": prompt,
    },
    "tests": {
        "defaults": {
            "min_pass_rate": 0.5,
        },
        "clinical": {
            "medfuzz": {
                "min_pass_rate": 0.1,
                "attacker_llm": {
                    "model": "gpt-4o",
                    "hub": "openai",
                    "type": "chat",
                },                
            }
        }
    }
}
```

```python
harness = Harness(
    task="question-answering",
    model={
        "model": "gpt-4.1-mini",
        "hub": "openai",
        "type": "chat",
    },
    data={
        "data_source": "MedQA",
        "split": "test-tiny",
    },
    config=config
)
```
execution:
```python
harness.generate().run().report()
```
<img width="648" height="80" alt="image" src="https://github.com/user-attachments/assets/d134084c-7580-427f-8c50-cb44bd76d0a4" />

Example:
<img width="1757" height="281" alt="image" src="https://github.com/user-attachments/assets/b4fbe5fa-73fd-45db-bfc5-92f6e0e0e2f1" />

---

### 🎲 Randomized Options in QA Tasks  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Pacific-AI-Corp/langtest/blob/main/demo/tutorials/test-specific-notebooks/RandomOptions.ipynb)

LangTest now supports **randomized option ordering** in multiple-choice evaluations to mitigate positional bias.  

**Key Features:**  
- Prevents models from exploiting fixed option order.  
- Strengthens the fairness and validity of QA benchmarks.  
- Easy integration into robustness test suites.  

**How it works:**
```python
#Import Harness from the LangTest library
from langtest import Harness
import os

os.environ['OPENAI_API_KEY'] = '<API KEY>'  # Add your OpenAI API key here
os.environ['OPENROUTER_API_KEY'] = '<API KEY>'
```
Prompt:
```python
prompt = """
You will answer **single-answer multiple-choice** questions.

**Do this:**

1. Read the question carefully (watch for words like **NOT**, **EXCEPT**, **BEST**, **MOST**).
2. Review **all** options A-E.
3. Choose the **one** best correct option.

**Output rules (STRICT):**

* Return **exactly one line** in the format: `LETTER. OPTION_VALUE`
* Keep the option text **exactly as given** (spelling/case/punctuation).
* **No** explanations, no extra text, no quotes, no code blocks, no trailing punctuation after the option text.
* If options include “None of the above” / “All of the above,” treat them like any other option.

**Template:**
Question:
{question}
Options:
{options}
Answer:

"""
```
Harness setup:
Config:
```python
from langtest.types import HarnessConfig

config : HarnessConfig = {
    "model_parameters": {
        "user_prompt": prompt,
    },
    "tests": {
        "defaults": {
            "min_pass_rate": 0.5,
        },
        "robustness": {
            "randomize_options": {
                "min_pass_rate": 0.8,             
            }
        }
    },
    "evaluation": {
        "metric": "llm_eval",
        "model": "gpt-4o",
        "hub": "openai",
    }
}
```

```python
harness = Harness(
    task="question-answering",
    model={
        "model": "mistralai/mistral-medium-3.1",
        "hub": "openrouter",
        "type": "chat",
    },
    data={
        "data_source": "MedQA",
        "split": "test-tiny",
    },
    config=config
)
```
execution:
```python
harness.generate().run().report()
```
<img width="697" height="70" alt="image" src="https://github.com/user-attachments/assets/fae0a0bc-c41b-44d4-b0f9-f3bf3bc8bb9e" />

Results:
<img width="1454" height="229" alt="image" src="https://github.com/user-attachments/assets/8c929580-f0d4-4db4-b917-7a6aeed0dc0c" />

---

### 📝 ACI-Bench: Ambient Clinical Intelligence Benchmark  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Pacific-AI-Corp/langtest/blob/main/demo/tutorials/llm_notebooks/dataset-notebooks/ACI_Bench.ipynb)

We’ve added support for **ACI-Bench**, a new benchmark focused on automatic visit note generation in clinical contexts.  

**Key Features:**  
- Evaluates LLMs in real-world clinical documentation tasks.  
- Focus on accuracy, completeness, and contextual relevance.  
- Provides a foundation for testing AI-driven scribing systems.  

**How it Works:**

```python
import os
from langtest import Harness

os.environ["OPENAI_API_KEY"] = "<YOUR_API_KEY>"
```

Harness Config:
```python
from langtest.types import HarnessConfig

config: HarnessConfig = {
    "evaluation": {
        "model": "gpt-4o-mini",
        "hub": "openai",
        "metric": "llm_eval",
        "threshold": 9,

    },
    "tests": {
        "defaults": {
            "min_pass_rate": 0.8,
        },
        "clinical": {
            "clinical_note_summary": {
                "dataset_path": "aci-bench",
            }
        }
    }
}
```
```python
harness = Harness(
    task="summarization",
    model=
        {
        "model": "gpt-4.1-mini",
        "hub": "openai",
        "type": "chat"
    },
    data=[],
    config=config
)
```

Execution:
```python
harness.generate().run().report()
```
<img width="712" height="87" alt="image" src="https://github.com/user-attachments/assets/6f9e58c2-5518-4821-9f27-48ed79b390b5" />

---

### 💬 MTS-Dialog: Clinical Summary Evaluation  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Pacific-AI-Corp/langtest/blob/main/demo/tutorials/llm_notebooks/dataset-notebooks/MTS_Dialog.ipynb)

LangTest now supports the **MTS-Dialog dataset** for dialogue-to-summary generation, including structured (sectioned) summaries.  

**Key Features:**  
- Evaluates models on summarizing doctor-patient dialogues.  
- Supports sectioned outputs with headers + content for clarity.  
- Benchmarks dialogue comprehension and summarization accuracy.  

**How it Works:**

```python
import os
from langtest import Harness

os.environ["OPENAI_API_KEY"] = "<YOUR_API_KEY>"
```

Harness Config:
```python
from langtest.types import HarnessConfig


config: HarnessConfig = {
    "evaluation": {
        "model": "gpt-4o-mini",
        "hub": "openai",
        "metric": "llm_eval",
        "threshold": 9,

    },
    "tests": {
        "defaults": {
            "min_pass_rate": 0.8,
        },
        "clinical": {
            "clinical_note_summary": {
                "dataset_path": "mts-dialog",
                "num_samples": 50,    
            }
        }
    }
}
```
```python
harness = Harness(
    task="summarization",
    model=
        {
        "model": "gpt-4.1-mini",
        "hub": "openai",
        "type": "chat"
    },
    data=[],
    config=config
)
```
Execution:
```python
harness.generate().run().report()
```
<img width="721" height="81" alt="image" src="https://github.com/user-attachments/assets/02013c55-7e40-4ce5-9c51-fb40d7ea7970" />

---

### 🧠 MentalChat16K Clinical Evaluation Support  
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Pacific-AI-Corp/langtest/blob/main/demo/tutorials/llm_notebooks/dataset-notebooks/Mental_Health.ipynb)

We’ve added support for the MentalChat16K dataset, a specialized benchmark for evaluating LLMs in mental health–related dialogues. This dataset focuses on empathy, coherence, and safety, making it particularly valuable for sensitive clinical evaluation tasks.  

**Key Features:**  
- Evaluates models on mental health dialogue safety and appropriateness. 
- Benchmarks empathy, coherence, and adherence to safe conversational norms.  

**How it works:**  

```python
from langtest import Harness
import os

os.environ["OPENAI_API_KEY"] = "<YOUR_API_KEY>"
```

Harness Setup:

```python
harness = Harness(
    task="question-answering",
    model=
        {
        "model": "gpt-4.1-mini",
        "hub": "openai",
        "type": "chat"
    },
    data=[],
    config={
        "evaluation": {
            "metric":"llm_eval",
            "model":"gpt-4o-mini",
            "hub":"openai",
            "threshold": 8 
        },
        "tests": {
            "defaults": {
                "min_pass_rate": 0.7,
            },
            "clinical": {
                "mental_health": {
                    "sample_size": 50, # Number of samples to test
                }
            },
        }
    }
)
```

```python
harness.generate().run().report()
```
<img width="675" height="85" alt="image" src="https://github.com/user-attachments/assets/ece701a0-5756-4cf8-8d02-77748cb9d968" />

---

## What's Changed
* Feature/implement the amega by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1188
* Feature/implement the fuzz tests in robustness by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1190
* update: enhancing by migrating pydantic v1 basemodel to v2 by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1194
* Feat/implement mts dialog based clinical summary evaluation by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1192
* refactor: updated the poetry lock file. by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1197
* Fix/1198 incompatibility detected in qasample during bias test execution by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1199
* fix: base_url can add in model_parameters. by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1201
* feat: add support for randomized options in question-answering tasks by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1203
* Replace pkg_resources with importlib.resources for Modern Resource File Handling by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1207
* chore: update poetry version to 2.1.3 in build workflow by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1211
* fix: update Poetry version to 2.1.3 in GitHub Actions workflow by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1215
* Revert "chore: update poetry version to 2.1.3 in build workflow" by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1213
* PAL-404 Updated dependencies versions in pyproject.toml and poetry.lock by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1205
* Refactor/replace links from johnsnowlabs to pacific ai corp by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1209
* Feature/implement the mentalchat16k dataset support for clinical evaluation by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1218
* Updates/websites updates for 270 by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1221
* updated: api documentation with pacific ai links by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1222
* Release/2.7.0 by @chakravarthik27 in https://github.com/Pacific-AI-Corp/langtest/pull/1219


**Full Changelog**: https://github.com/Pacific-AI-Corp/langtest/compare/2.6.0...2.7.0
</div>
{%- include docs-langtest-pagination.html -%}
