# 🌌 DreamReader: Antigravity Vision 🎙️✨

**DreamReader** is a premium, AI-powered Flutter application designed to decrypt the mysteries of your unconscious mind. Using a state-of-the-art "Antigravity" cosmic UI, it transforms your spoken or typed dreams into deep psychological insights and manifesting visuals.

---

## 🚀 Experience the Cosmic Flow
- **🎙️ Sacred Voice Input:** A high-fidelity voice recording interface with real-time waveform visualization.
- **🔮 Gemini 2.0 Core:** Leverages the latest Gemini 2.0 Flash model to interpret dreams through psychological, mystical, and symbolic lenses.
- **🎨 Manifesting Visuals:** Automatically generates vivid, AI-driven artwork (via DALL-E 3) that captures the soul of your dream.
- **💎 Antigravity Aesthetic:** A meticulously crafted UI featuring deep-space glassmorphism, nebula backgrounds, and high-frequency animations.
- **📝 Manual Vision Fallback:** Seamlessly switch to text input if the environment isn't suited for voice.

---

## 🛠️ Tech Stack
- **Framework:** Flutter (3.x)
- **State Management:** Riverpod (Ref-based Modern Paradigm)
- **AI Providers:** 
  - **Google Gemini:** Deep Dream Analysis
  - **OpenAI DALL-E 3:** Visual Manifestation
- **Typography:** Orbitron (Futuristic Headers), Rajdhani (Cybernetic Body)
- **Animations:** [flutter_animate](https://pub.dev/packages/flutter_animate) for cinematic drifts and ripples.

---

## 📦 Installation & Setup

### 1. Prerequisites
- Flutter SDK installed and configured.
- Valid API keys for **Google Gemini** and **OpenAI**.

### 2. Clone the Repository
```bash
git clone https://github.com/yourusername/dream_reader.git
cd dream_reader
```

### 3. Launching with AI Core
To enable the AI interpretations and image generation, you must pass your API keys during the run or build command:

```bash
flutter run \
  --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY \
  --dart-define=OPENAI_API_KEY=YOUR_OPENAI_KEY
```

> [!TIP]
> Use the provided `.vscode/launch.json` (template) to avoid re-typing keys every time.

---

## 📁 Project Structure
The project follows a **Feature-Based Architecture** for maximum scalability:

```text
lib/
├── features/
│   └── dream/           # Core Feature: Recording, Analysis, Feed
│       ├── presentation/ # Antigravity Screen & Widgets
│       └── domain/       # Entities & Repository Interfaces
├── data/
│   ├── repositories/    # AI Core Implementations
│   └── services/        # Voice & Image API Services
└── core/
    └── widgets/         # Shared UI Components (GlassContainer, etc.)
```

---

## 📜 License
*DreamReader is an experimental fusion of art and AI. Free your mind.* 🌌✨
