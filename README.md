# FormLang++: A Domain-Specific Language & HTML Form Generator

## 📖 Overview
FormLang++ is a **Domain-Specific Language (DSL)** for defining web form structures.  
It uses **Lex** and **Yacc (Bison)** to parse custom `.form` scripts and generate fully-functional **HTML forms with built-in validation**.

This project demonstrates concepts in **compiler construction**, including grammar design, lexical analysis, parsing, semantic actions, and code generation.

---

## 🚀 Features
- **Grammar Design (EBNF):** Define form metadata, sections, fields, attributes, and conditional validation.  
- **Lexical Analysis:** Tokenizes form syntax, attributes, operators, and literals.  
- **Parsing & Code Generation:** Validates syntax and generates semantic HTML with `fprintf()`.  
- **Validation Logic:** Supports simple conditions (e.g., `if age < 18`) with custom error messages.  
- **Error Handling:** Reports malformed scripts with meaningful messages.  
- **Demo Ready:** Includes sample `.form` scripts and corresponding generated `.html` outputs.  

---

## 🛠️ Tools & Technologies
- **Lex (Flex)**
- **Yacc (Bison)**
- **C**
- **HTML**
- **EBNF Grammar**

---

## 📂 Project Structure
```
├── lexer.l         # Lexical analyzer
├── parser.y        # Grammar and parser rules
├── samples/        # Example .form scripts and generated outputs
├── README.md       # Project documentation
```

---

## ⚡ Getting Started

### 1️⃣ Install Dependencies
Make sure you have the following installed:

#### On Ubuntu/Debian:
```bash
sudo apt update
sudo apt install flex bison gcc -y
```

#### On Arch Linux:
```bash
sudo pacman -S flex bison gcc
```

#### On macOS (with Homebrew):
```bash
brew install flex bison gcc
```

---

### 2️⃣ Build the Project
Run the following inside the project root:
```bash
bison -d parser.y
flex lexer.l
gcc -o formgen parser.tab.c lex.yy.c -lfl
```

---

### 3️⃣ Run the Form Generator
```bash
./formgen < samples/registration.form > output.html
```

---

### 4️⃣ Open the Generated Form
```bash
xdg-open output.html   # Linux
open output.html       # macOS
start output.html      # Windows
```

---

## 🎯 Learning Outcomes
- Practical experience in DSL and compiler construction  
- Understanding of parsing theory and language design  
- Translation of high-level form definitions into executable HTML  
- Hands-on use of Lex, Yacc, and C  

---

## 📹 Demo
The repository includes:
- Example `.form` scripts  
- Generated `.html` output files  

Provide a `.form` script as input, and redirect the output to an `.html` file.
# FormLang++: A Domain-Specific Language & HTML Form Generator

## 📖 Overview
FormLang++ is a **Domain-Specific Language (DSL)** for defining web form structures.  
It uses **Lex** and **Yacc (Bison)** to parse custom `.form` scripts and generate fully-functional **HTML forms with built-in validation**.

This project demonstrates concepts in **compiler construction**, including grammar design, lexical analysis, parsing, semantic actions, and code generation.

---

## 🚀 Features
- **Grammar Design (EBNF):** Define form metadata, sections, fields, attributes, and conditional validation.  
- **Lexical Analysis:** Tokenizes form syntax, attributes, operators, and literals.  
- **Parsing & Code Generation:** Validates syntax and generates semantic HTML with `fprintf()`.  
- **Validation Logic:** Supports simple conditions (e.g., `if age < 18`) with custom error messages.  
- **Error Handling:** Reports malformed scripts with meaningful messages.  


---

## 🛠️ Tools & Technologies
- **Lex (Flex)**
- **Yacc (Bison)**
- **C**
- **HTML**
- **EBNF Grammar**

---

## 📂 Project Structure
```
├── lexer.l         # Lexical analyzer
├── parser.y        # Grammar and parser rules
├── README.md       # Project documentation
```

---

## ⚡ Getting Started

### 1️⃣ Install Dependencies
Make sure you have the following installed:

#### On Ubuntu/Debian:
```bash
sudo apt update
sudo apt install flex bison gcc -y
```

#### On Arch Linux:
```bash
sudo pacman -S flex bison gcc
```

#### On macOS (with Homebrew):
```bash
brew install flex bison gcc
```

---

### 2️⃣ Build the Project
Run the following inside the project root:
```bash
bison -d parser.y
flex lexer.l
gcc -o formgen parser.tab.c lex.yy.c -lfl
```

---

### 3️⃣ Run the Form Generator
```bash
./formgen < samples/registration.form > output.html
```

---

### 4️⃣ Open the Generated Form
```bash
xdg-open output.html   # Linux
open output.html       # macOS
start output.html      # Windows
```

---

## 🎯 Learning Outcomes
- Practical experience in DSL and compiler construction  
- Understanding of parsing theory and language design  
- Translation of high-level form definitions into executable HTML  
- Hands-on use of Lex, Yacc, and C  

---

## 📹 Demo
The repository includes:
- Example `.form` scripts  
- Generated `.html` output files  
 

Provide a `.form` script as input, and redirect the output to an `.html` file.
