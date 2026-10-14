---
title: Portfolio
author: Bibek K C
subtitle: Full-Stack AI Engineer
date: "[kc-bibek.com.np](https://kc-bibek.com.np) · [info@kc-bibek.com.np](mailto:info@kc-bibek.com.np) · [github.com/bibekyess](https://github.com/bibekyess) · [linkedin.com/in/bibek44](https://www.linkedin.com/in/bibek44)<br />Updated October 2026"
---

<!--
SOURCE OF TRUTH. Edit only this file, then run ./build-portfolio.ps1 to regenerate
portfolio.html and portfolio_bibek.pdf. Never edit those two by hand.

Three sections, each newest first: Selected Projects (products built end to end),
Research and Applied ML Projects (the model or the method was the deliverable), and
Earlier Projects and Coursework. A new project goes in the section its artifact fits,
not the one its year suggests.

Template for a new project. Copy this block, keep the field order, drop fields that
don't apply. The HTML comment is metadata: it never appears in the HTML or the PDF.

## Project Name <span class="tag">Web app</span> <span class="year">(2026)</span>
<!~~ year: 2026 | tags: tag-one, tag-two | featured: true ~~>

The spans are what actually render; the comment below them is metadata only. Keep the
year in sync with the comment, and drop the year span entirely for a project whose
year is still unknown (`year: ?`).

Selected Projects carries a form-factor badge as well, because that section is about
shipped products; the other two sections carry the year alone. The badge vocabulary is
a closed set of four, and stays a closed set:

    Web app · Mobile app · Desktop app · MCP server

Two words is the ceiling. Longer than that and it stops reading as a badge and starts
reading as a subtitle, so platform and shape detail ("Windows and macOS", "site plus
CRM") belong in the prose, not in the pill. A project genuinely shipping two artifacts
takes two badges, written adjacent with no space between the spans so the CSS margin
alone sets the gap. Say "Web app", not "Web platform": platform implies an API or SDK
others build on, and invites a question there's no answer to. Don't say "Win32":
these are Electron apps, and the term is both wrong and dated.

House style, so the three sections read as one document:

  * Every project in Selected Projects and Research opens with ONE bold thesis
    sentence: an engineering decision or a finding, never a credit claim. Projects in
    Earlier Projects open with no bold lead at all.
  * No paragraph over ~120 words. Split at the next idea; a wall of text loses the
    30-second skim no matter how good the sentences are.
  * Bold = a thesis or a hard number. Italic = the one word carrying a distinction.
    Never bold a tool name, that is what the Tools row is for.
  * Earlier Projects entries stay under ~60 words including the Role line. That
    section exists to show breadth, not to be read.
  * At least one concrete number per Selected project.
  * A colon separates a project name from its tagline, never an em dash.
  * Em dashes are rationed: a handful in the whole document, none of them
    decorative. At any real density they read as machine-written, and the
    substitute is almost always a comma, a colon, or a full stop. Note the build
    runs pandoc with `+smart`, so a literal `---` in this file becomes one too.

One to three paragraphs of prose. What it is, what you did, what came out of it.

- **Role:** Solo, or name the split on a team project. Stated on every Selected project.
- **Tools:** comma, separated, list
- **ML/Algorithms:** only if there's a real algorithm worth naming
- **Links:** [Label](url) · [Label](url)
-->

# Selected Projects

*Products, designed and built end to end.*

## KhururuAI: Work in Flow <span class="tag">Web app</span> <span class="year">(2026)</span>
<!-- year: 2026 | tags: agentic-ai, llm, langgraph, rag, microservices | featured: true -->

**The point of this project is access.** Capable AI tools price out the people
who would gain most from them, while every major provider (Groq, Cerebras,
NVIDIA, Google, Mistral) gives away a free tier that goes unclaimed because
claiming it means holding an API key. KhururuAI pools that free capacity into a
product anyone can just open and use: no payment, no API key, no account at all
for the first five turns. It runs today on my own pooled keys, roughly **2.3B
tokens** of budget; the version I'm working toward provisions each user's *own*
free tier at sign-in, so the ceiling scales with users instead of being divided
among them, and extends the agents to Nepali language work: drafting, and
filling out forms in Nepali.

A user writes what they want in plain language, an LLM router picks one of six
specialists, and that specialist returns the finished thing: a researched answer
with live citations, a slide deck, a PDF, working code, an image, or ordinary
conversation. Uploaded documents are parsed, embedded and retrieved with
page-accurate citations, **PDF, DOCX, HWP and HWPX alike**, so the formats people
actually receive are not a reason to be locked out. Turns stream over SSE as
typed events, so the interface names the specialist at ~1–2s and the model that
is writing before the first token exists.

Staying free without falling over is the engineering problem. One
OpenAI-compatible gateway fronts every provider, collapsing three vendor SDKs
into a single client where "which provider" becomes "which model id"; agents are
pinned to capability *slots* rather than vendors, so a model that runs dry is a
one-line swap and an exhausted route falls back on its own.

Free access then sits behind two ceilings doing different jobs: a guest
allowance that deliberately never refills, and a per-IP daily budget that stops
the endpoint being farmed. Five Node services plus Redis, Qdrant and MinIO behind
a React SPA, reproducible with one Docker Compose command, with the decisions
recorded as ADRs.

**v2, coming soon, turns the assistant into a team.** Instead of one chat that
returns a finished artifact, you spin up several AI teammates, each driving its
own virtual PC. The human never leaves the loop: you can step into any bot's
desktop at any moment to hand it a file, clear a CAPTCHA, or type in a password
or anything else that should never pass through a model, then step back out and
let the agent carry on from where you left it. An early preview is live.

- **Role:** Solo. Architecture, all five services, the SPA and deployment.
- **Tools:** Node.js, Express, LangGraph.js, React, TypeScript, MongoDB, Redis, Qdrant, MinIO/S3, Docker Compose, nginx, Firebase Auth, Tavily
- **ML/Algorithms:** LLM intent routing across an agent roster; multi-provider model routing with exhaustion fallback; document RAG (page-aware chunking, Gemini embeddings, score-floored retrieval under a hard context budget, validated citations)
- **Links:** [khururu.com](https://khururu.com) · [v2 preview: sangi.khururu.com](https://sangi.khururu.com)

## Charak: Medical Research Assistant <span class="tag">Web app</span><span class="tag">MCP server</span> <span class="year">(2026)</span>
<!-- year: 2026 | tags: agentic-ai, llm, tool-calling, retrieval, data-viz, mcp, fastapi | featured: true -->

**For deterministic work, a tool-calling agent beats code-gen or one big prompt.**
Charak answers natural-language clinical questions from live PubMed literature and
ClinicalTrials.gov v2 records, and charts the answer when the question is really
about a distribution. The LLM owns language and control flow only, orchestrating
typed Python tools, and never sees or writes a number. State stays server-side and
it passes only opaque dataset handles, so it cannot emit a wrong figure because it
is never handed one. Chart-type selection is deterministic rules; the "no matching
trials" reply is code-gated rather than left to judgment. That costs more
round-trips, but each is a short tool call instead of a wall of records pushed
through context — cheaper per query and structurally correct.

The backend renders nothing: it returns a small flat JSON spec that Vega-Lite draws
on the client, thin enough that one response feeds the chat UI, the
`POST /visualize` API and a standalone MCP server unchanged.

**The hard part was the public API, not the model.** I verified every capability
with live `curl` first, which caught the wrong assumptions. The obvious filters
(`filter.phase`, `filter.country`) don't exist; real narrowing is Essie,
`AREA[Phase]PHASE3`. And the one aggregation endpoint can't be scoped to a query
and returns no trial IDs, so it can't back citations either.

With no server-side aggregation, counts are resolved in tiers: exact from the full
corpus, exact via a cheap per-bucket `countTotal` query when it's too large to
fetch, sampled-but-flagged only for unbounded fields. Because aggregation walks
records instead of asking for a summary, **every bar carries the trial IDs that
built it**.

- **Role:** Solo. API research, agent and tool design, backend and frontend.
- **Tools:** Python, FastAPI, Pydantic v2, MCP (Model Context Protocol), Vega-Lite, vis-network, Server-Sent Events, Docker Compose, Caddy, pytest, uv
- **ML/Algorithms:** Tool-calling agent loop with server-side state handles (no numeric values in context); three-tier exact-count resolution over a non-aggregating API; deterministic data-shape → chart-type selection; entity-normalized co-occurrence network construction; LLM access through the same OpenAI-compatible gateway as KhururuAI, so it runs on pooled free-tier
- **Links:** [charak.khururu.com](https://charak.khururu.com) · [GitHub](https://github.com/bibekyess/Query-to-Visualization)

## Bintech International <span class="tag">Web app</span> <span class="year">(2026)</span>
<!-- year: 2026 | tags: full-stack, nextjs, payload-cms, llm, self-hosted, devops | featured: true -->

**Built to survive being handed over.** Bintech is a B2B hardware supplier in
Nepal, and I built all of it: site, CRM, assistant, server. Nobody there writes
code, so the design is only correct if a salesperson can add a product, publish
it and answer a customer without me. So the catalogue lives in Payload CMS 3 on
Postgres: staff add and publish products from a browser admin panel, with the
field labels written for a salesperson rather than for me. Who can see what is
enforced inside the database query rather than filtered out in code afterwards,
so an unpublished draft is never fetched for a visitor at all. Inquiries work
the opposite way: anyone can submit one, nobody outside the company can read
them, and staff can read but not edit what the customer wrote. The only
editable field is the status, New → Contacted → Closed.

The site is built to keep working when its dependencies don't: every catalogue
query falls back to a built-in list of products, so a Postgres outage degrades
to that list instead of a blank page, and inquiry emails are sent only after the
lead is saved to the database, so a mail outage costs a notification, never a
lead. It self-hosts on one VPS via Docker Compose behind Caddy, deployed over
SSH by a GitHub Actions job that holds no repo permissions and can run only one
fixed deploy command on the server.

**The assistant is deliberately the predictable kind: grounded, not fine-tuned,
and always in sync with the live catalogue.** Each request flattens that catalogue
into one compact line per product behind a 60s cache and pins it into a system
prompt that forbids inventing prices and
hard-codes the only two legal URL shapes (LLMs cheerfully guess
`/products/monitors`, which 404s). So a price edit in the CRM reaches the bot's
answers within a cache window, and it cannot quote a number that isn't in the
database.

- **Role:** Solo. Site, CRM, assistant, VPS, domain, DNS and mailboxes.
- **Tools:** Next.js 16 (App Router), React 19, TypeScript, Tailwind CSS v4, Payload CMS 3, PostgreSQL 17, Drizzle migrations, Nodemailer/SMTP, sharp, Motion, Docker Compose, Caddy, GitHub Actions
- **ML/Algorithms:** Catalogue-grounded LLM assistant. Live DB → compact token-efficient context behind a TTL cache, guardrailed system prompt (no invented prices/specs, closed link vocabulary, out-of-scope hand-off), SSE → plain-text delta re-emission
- **Links:** [bintechint.com](https://bintechint.com)

## AirConnect: Proximity-Based Social Discovery <span class="tag">Mobile app</span> <span class="year">(2025)</span>
<!-- year: 2025 | tags: mobile, react-native, realtime, backend, redis, docker, product | featured: true -->

**Ultra-Wideband was the bet, and the hardware wasn't ready.** A friend and I
wanted to start a company, and this was my idea. You are on a subway and the person across from you is reading a book you love.
You want to say something, but the only options are walking up to a stranger or
saying nothing, so you say nothing. AirConnect made the first move small: ping
the one person in your line of sight, and let them ignore it if they want.

That premise needs direction, not distance. UWB is the only widely shipped radio
that gives angle of arrival rather than just range, and "that person, over there"
is an angle problem. Bluetooth knows someone is nearby, never which one. The UWB
SDKs proved too unstable to build on, and without direction the premise was gone.
We pivoted to GPS-based nearby discovery, which put us in dating-app territory,
where Apple now rejects new entrants that aren't meaningfully differentiated. So we
stopped. **Two people, six weeks**: a working real-time app, and a clear answer to
why the idea doesn't survive current hardware and platform policy.

An Expo/React Native client and a Node + Socket.IO backend: nearby discovery,
matching, chat, and live location sharing on a map, with Redis as the primary
datastore. My friend built the Expo foundation and owned the map/GPS and chat
features. **I owned the backend and infrastructure**: Docker/Compose, identity
and access management (IAM), a PostgreSQL migration path alongside Redis, and the
welcome/signup/onboarding flow, plus debugging help on the map (marker-flicker
fix and compass heading).

- **Role:** Two-person team. I owned the backend, infrastructure and IAM; my friend owned the map/GPS and chat.
- **Tools:** Expo, React Native, TypeScript, Node.js, Express, Socket.IO, Redis, PostgreSQL, Docker Compose, cloudflared

## B-Assist (Better-Assistant) <span class="tag">Desktop app</span> <span class="year">(2024)</span>
<!-- year: 2024 | tags: desktop-app, llm, electron, on-device | featured: true -->

**The assistant should come to your text, not your text to the assistant.** Every AI
writing tool I used meant the same round-trip: leave the editor, paste into ChatGPT,
read the answer, copy it back, paste again. B-Assist collapses that to a keystroke.
Select text anywhere (an email, a Word document, an IDE), press `ctrl+shift+X`
(`cmd+shift+X` on macOS), pick an action, and the processed text replaces your
selection in place. You never leave the window you were writing in.

Working in *every* editor rules out integrating with any of them, so it sits under the
apps rather than inside them: a global hotkey opens a small window, and robotJS drives
the OS clipboard and keystrokes to lift the selection and type the result back — the
same path whether the target is Gmail, Word or VS Code, with no per-app plugin to
write or maintain. Models run locally through Ollama, which does two jobs at once:
there is no API key to hand a non-technical user, and drafts being rewritten never
leave the machine. It ships as a one-click executable for Windows and macOS, with
grammar and spelling correction and English→Korean translation as the actions
implemented.

Any local model works; the recommended default is Qwen3.5-4B, small enough to
run on an ordinary laptop. The same idea later became **a shipped
product at the startup I work at**, SamuGen Plugin.

- **Role:** Solo.
- **Tools:** ElectronJS, ReactJS, robotJS, Ollama
- **Links:** [GitHub](https://github.com/bibekyess/B-Assist) · [Demo](https://github.com/bibekyess/B-Assist/blob/main/src/assets/demo.gif) · [SamuGen Plugin](https://ondevice.neoali.com/samugen-plugin)

## ReNameify: Content-Aware PDF Batch Renamer <span class="tag">Desktop app</span> <span class="year">(2024)</span>
<!-- year: 2024 | tags: desktop-app, electron, pdf, heuristics, non-technical-users | featured: true -->

**Written for one real user, not a spec.** My sister was renaming exported PDFs by
hand (opening each one, reading the header, retyping it), so she talked with me, and I watched
the actual workflow, and shipped a one-click Windows installer that does it in a
folder-at-a-time pass. It extracts each PDF's text, then scores lines with a
header-detection heuristic that rejects the things that look like titles but aren't:
page numbers (`page 12`, `- 12 -`), sentences ending in a full stop, lines that are
mostly punctuation, and anything outside a defined length range.

**Trust mattered more than accuracy here.** Nothing is renamed in place. Originals
stay untouched and copies land in a `renamed_files/` subfolder, a PDF that fails to
parse (scanned pages, no text layer) keeps its original name instead of erroring the
batch, and a first-run guided tour walks a non-technical user through the three
buttons. It survived contact with its one user, which is the only test that counted.

- **Role:** Solo.
- **Tools:** ElectronJS, Node.js, pdf-parse, fs-extra, Shepherd.js, Winston, electron-builder (NSIS one-click installer)
- **ML/Algorithms:** Rule-based header extraction from first-page text: length banding, terminal-punctuation and page-number rejection, special-character-ratio filtering with a Hangul-safe character class, document-specific anchor matching, and filename sanitization with graceful fallback to the original name
- **Links:** [GitHub](https://github.com/bibekyess/ReNameify)

# Research and Applied ML Projects <span class="year">(2023–2024)</span>

*Where the model or the method was the deliverable.*

## FastRAG: Self-Hosted Document RAG Backend <span class="year">(2024)</span>
<!-- year: 2024 | tags: rag, retrieval, fastapi, qdrant, llama-cpp, self-hosted, docker | featured: true -->

**No API key, no data leaving the machine.** FastRAG is a document Q&A backend that
comes up with a single `docker compose up`: a FastAPI parse/chat service, Qdrant for
vectors, a CUDA llama.cpp server running a quantized Llama-3.2-3B, and a Gradio demo
UI.

Ingestion offers two paths: a custom PyMuPDF reader with tunable chunk size and
stride, plus an optional bridging pass that stitches the tail of one page to the head
of the next so an answer split across a page break is still retrievable as one chunk;
or layout-aware Markdown chunking for documents where structure carries the meaning.

Retrieval is bge-m3 dense search with a score floor, and the prompt is written to
refuse rather than improvise when the retrieved references don't cover the question.
Follow-ups can be rewritten into standalone queries against conversation history kept
in Qdrant, and answers stream token-by-token from llama.cpp through FastAPI to the UI,
with per-response latency logged and shown to the user.

- **Role:** Solo.
- **Tools:** Python, FastAPI, Qdrant, llama.cpp (CUDA server), LlamaIndex, PyMuPDF/pymupdf4llm, LangChain text-splitters, Gradio, Docker Compose, Poetry, pre-commit
- **ML/Algorithms:** BAAI/bge-m3 dense embeddings with cosine search and a score threshold; on-disk vectors and memmap-tuned Qdrant collections for low-RAM hosts; page-boundary overlap chunking vs. layout-aware Markdown chunking; history-conditioned query rewriting; grounded-answer prompt with an explicit refusal path
- **Links:** [GitHub](https://github.com/bibekyess/FastRAG)

## Probabilistic Multiview Object-Pose Estimation <span class="year">(2023)</span>
<!-- year: 2023 | tags: research, computer-vision, robotics, pose-estimation | featured: true -->

**One fused pose distribution per object, rather than a best-view pick.** Single-view
estimators disagree with each other, and choosing between them throws information
away. We associated multiple estimation results with scene graphs, combined the pose
distributions coming out of single-view estimators, and constructed a unified scene
graph by predicting one pose distribution per object. On table-top object-pose
scenarios the approach **beat three baseline methods** on both position and
orientation accuracy.

- **Role:** Neural architecture research for pose estimation and scene graph generation, then training and combined efficient inference. My teammate handled environment setup, simulation dataset creation, and visualization.
- **Links:** [Draft paper](https://tinyurl.com/kroc-draft)

## 6D Pose Estimation and Scene Graph Generation <span class="year">(2023)</span>
<!-- year: 2023 | tags: computer-vision, robotics, pose-estimation | featured: true -->

**Two heavy frameworks in one pipeline, and the cost shows up as framerate.** I
combined the [Cosypose](https://arxiv.org/pdf/2008.08465.pdf) framework for 6D pose
with [Neural-Motif](https://arxiv.org/pdf/2002.11949.pdf) for scene graph generation
and ran experiments on custom cup datasets, a single-camera setup producing both 6D
pose and a dynamic scene graph. For 6 cups, with pose estimation plus relationship and
attribute predictions, the combined framework ran at **1.25 frames/s**.

- **ML/Algorithms:** Cosypose: CNN with geometric optimization (ICP registration and non-linear optimization via Levenberg-Marquardt); Neural-Motif: Region Proposal Network with bi-directional LSTM
- **Links:** [Demo](https://tinyurl.com/pose-sgg-demo)

## MBTI Prediction <span class="year">(2023)</span>
<!-- year: 2023 | tags: nlp, classification, hackathon, bert | featured: true -->

**One classifier pair per MBTI axis, not one model for all sixteen types.**
Submitted to the Qualcomm-KAIST Innovation Awards Hackathon in May 2023, predicting
MBTI (a widely used personality assessment) from text. The model is a hierarchical
classifier: 4 fine-tuned KoBERT classifiers and 4 SVM classifiers, one pair per
section of the MBTI test.

For robustness I augmented the data by paraphrasing long answers with
google-t5-base, and ran EDA on the question information to extract a new feature set
from the questions themselves. Fine-tuning KoBERT meant adding a fully connected
layer with softmax activation at the end, then adaptively fine-tuning by varying the
amount of layer-freezing in two steps.

I placed **3rd on the Phase-2 private leaderboard**. The slides cover the results,
the other approaches I tried, and future work.

- **ML/Algorithms:** KoBERT fine-tuning, SVM, hierarchical classification, paraphrase-based data augmentation
- **Links:** [Presentation](https://docs.google.com/presentation/d/1wI6ntcfXGO4jeU2F1QvRxNai4WugMhVetFbYGH3Zo4M/edit?usp=sharing)

## ESL Fusion: Junction Asia Hackathon <span class="year">(2023)</span>
<!-- year: 2023 | tags: hackathon, product, forecasting, data-viz | featured: false -->

**Electronic shelf labels as the output device for a store recommender.** Using
SOLUM's ESL hardware, we built recommendation and stock tracking for offline stores
on displays cheap and low-power enough to scale to every shelf. Stock data fed both
a visual analysis layer for insights and a time-series model projecting the next
day's sales.

- **Role:** Team lead and product. I ran brainstorming, assigned roles and built the presentation slides. On the technical side I worked out from SOLUM's API manuals how to POST our content to the ESL screens, and built a QR-code-accessible web dashboard so customers on the local network could see the visualizations.
- **Tools:** REST API, qrcode, Dash HTML, Matplotlib, Flask, Figma
- **Links:** [GitHub](https://github.com/abbasmammadov/JunctionAsia2023_SOLUM/tree/main)

# Earlier Projects and Coursework

*University coursework, team projects and first builds.*

## B-bot (Personal Chatbot) <span class="year">(2023)</span>
<!-- year: 2023 | tags: nlp, chatbot, streamlit | featured: false -->

An early resume chatbot, pre-embeddings: an MLP classifier over a Bag of Words
representation maps a question to one of a set of predefined tags and returns the
matching answer, with stemming and spell-checking on the way in. Streamlit front
end, hosted on Streamlit Cloud.

- **Tools:** Streamlit-chat, PyTorch, PySpellchecker, NLTK
- **ML/Algorithms:** Multi-Layer Perceptron classifier, Bag of Words representation
- **Links:** [Live chatbot](https://bibekbot.streamlit.app/) · [GitHub](https://github.com/bibekyess/Personal-Chatbot)

## Paraphrase Generation (QCPG Replication)
<!-- year: ? | tags: nlp, research-replication, transformers | featured: false -->

We replicated *Quality Controlled Paraphrase Generation* (Bandel et al., ACL 2022).

- **Role:** Three improvements. I ablated the Quality Predictor to measure its actual contribution, swapped t5-base for multilingual mt5-base to train on Korean, and wrote the end-to-end inference pipeline from scratch.
- **Tools:** PyTorch, Matplotlib, transformers, Hugging Face models
- **Links:** [Replication report](https://tinyurl.com/qcpg-replication) · [GitHub](https://github.com/bibekyess/QCPG)

## AI-empowered F1/10 Autonomous Racing Car
<!-- year: ? | tags: robotics, ros, computer-vision, coursework | featured: false -->

Course team project. I set up the Jetson Xavier NX environment, networking and ROS
sensor packages, and owned perception. Yolact_ros instance segmentation proved too
computationally heavy, so obstacle avoidance moved to LIDAR and vision was cut back
to traffic-light detection by a rule-based crop, mask and count-pixels classifier.
AMCL and Hector Odom for localization, PID for control.

- **Tools:** Yolact_ros, OpenCV, Linux, ROS, NVIDIA SDK, Arduino IDE
- **Links:** [Final report](https://tinyurl.com/ee405-finalreport)

## Crypto Price Predictor
<!-- year: ? | tags: time-series, deep-learning, coursework | featured: false -->

Seven forecasting models for the price of bitcoin (recurrent, convolutional,
attention-based and a Bayesian network) across one-day and long-sequence horizons,
the longest running to 100 days.

- **Role:** I built the two deep models for the one-day task, one recurrent (bidirectional LSTM) and one convolutional (Conv1D), and ran multivariate forecasting with both.
- **Tools:** TensorFlow, Pandas, Matplotlib
- **ML/Algorithms:** Conv1D, bi-directional LSTM
- **Links:** [Project paper](https://tinyurl.com/cryptopredictor) · [GitHub](https://github.com/bibekyess/AI_practice/blob/main/Killionaire.ipynb)

## Movie Recommendation (Netflix Prize style)
<!-- year: ? | tags: recommender-systems, matrix-factorization, coursework | featured: false -->

Given `<USER ID>`, `<MOVIE ID>`, `<TIMESTAMP>` rows, I filled the missing `<RATING>`
column by factorizing the sparse user-movie utility matrix as R ≈ UVᵀ and training
both factors with Alternating Least Squares against RMSE. Two-fold normalization
first (user mean, then movie mean), then denormalize to predict.

- **Tools:** NumPy, Python
- **ML/Algorithms:** Dimensionality reduction (UV-decomposition), Alternating Least Squares

## Pintos
<!-- year: ? | tags: operating-systems, c, coursework | featured: false -->

pintos-kaist, a simple x86-64 OS framework forked from Stanford's Pintos and run
under QEMU, for my Operating Systems course. Across four projects: thread
synchronization with interrupts (semaphores, locks, condition variables), a system
call handler for I/O in user programs, virtual memory with page-fault handling and
swapping, and the basic file system.

- **Links:** [Project reference](https://casys-kaist.github.io/pintos-kaist/)

## Smart Home
<!-- year: ? | tags: iot, automation, coursework | featured: false -->

A security tech project detecting intruders and notifying the house owner.

- **Role:** Hardware setup (connecting the sensor to a Raspberry Pi via breadboard) and the Node-RED workflow, connecting each process to a Telegram bot for automated response.
- **Tools:** Node-RED
- **Links:** [Demo video](https://www.youtube.com/watch?v=YhccA0mm2YA) · [GitHub](https://github.com/bibekyess/HomeSec)

## Data Visualization Task
<!-- year: 2022 | tags: data-viz, d3 | featured: false -->

A visualization task given to me by a startup before hiring me as an intern in
Winter 2022.

- **Tools:** D3.js, Colab (data preprocessing), Flask, Heroku
- **Links:** [Live app](https://visualization-app.onrender.com/) · [GitHub](https://github.com/bibekyess/Bisonai-Assignment)
