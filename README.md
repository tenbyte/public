# Tenbyte Public Scripts

Welcome to the public script repository of **[Tenbyte Technologies GmbH](https://tenbyte.de)**.  
This repo contains small utility scripts, test setups, and self-hosted installation helpers — useful for DevOps, system administration, and developer environments.

> ✅ All scripts in this repository are open-source and provided "as-is".

---

## 🛠 What's Inside?

You’ll find:
- Installer scripts (e.g. [MinIO auto-installer](https://github.com/tenbyte/public/blob/main/install-minio.sh))
- Test tools (e.g. FFmpeg checkers, API test files)
- Useful CLI helpers for common Linux server tasks

We aim to keep these tools **lightweight**, **reusable**, and **easy to read**.

---

## 📚 Related Blog Posts

We regularly publish deep dives and tutorials on our official tech blog.  
For example, learn how to:
- Set up MinIO with our auto-installer
- Secure it behind a Cloudflare Zero Trust gateway
- Use it as a fast, S3-compatible storage solution

👉 **Read the full article here**:  
**[Self-Hosted MinIO + Cloudflare Zero Trust](https://tenbyte.de/blog)**

---

## ⚠️ Disclaimer

> All scripts and tools in this repository are provided **for educational and testing purposes** only.  
> **Use at your own risk.**  
> Tenbyte Technologies GmbH assumes no liability for data loss, damage, or misconfiguration caused by these tools.

Please **review each script before running it** on production systems. Always test in a safe environment first.

---

## 📦 How to Use

Clone the repository or download individual scripts:

```bash
git clone https://github.com/tenbyte/public.git
cd public
chmod +x install-minio.sh
./install-minio.sh
