# Fork Kit

Run the bootstrap once after creating a fork:

```bash
bash fork-kit/bootstrap-fork.sh
```

The script creates ignored local `.env` files with fresh development secrets, keeps existing env files intact, and installs an active scheduled upstream sync workflow at `.github/workflows/auto-sync.yml`.
