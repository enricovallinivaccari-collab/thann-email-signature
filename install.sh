#!/bin/bash
# Installa la firma THANN in Apple Mail, sostituendo una firma segnaposto creata in Mail.
# Prima di lanciarlo: crea la firma segnaposto in Mail (vedi README.md) e chiudi Mail con Cmd+Q.
set -euo pipefail

# ── Configurazione ──────────────────────────────────────────────────────────
# URL pubblico della cartella che contiene images/ (es. GitHub Pages), senza "/" finale
BASE_URL="https://TUO-UTENTE.github.io/thann-email-signature"
FACEBOOK_URL="https://www.facebook.com/"
LINKEDIN_URL="https://www.linkedin.com/"
INSTAGRAM_URL="https://www.instagram.com/"
WEBSITE_URL="https://www.example.com/"
# ────────────────────────────────────────────────────────────────────────────

DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ "$BASE_URL" == *TUO-UTENTE* ]]; then
  echo "Imposta BASE_URL in cima a install.sh con l'URL dove hai caricato images/." >&2
  exit 1
fi

if pgrep -xq Mail; then
  echo "Mail è aperto: chiudilo con Cmd+Q e rilancia lo script." >&2
  exit 1
fi

# Firme in iCloud Drive (sincronizzazione Mail attiva) o in locale; prende la più recente,
# cioè il segnaposto appena creato.
shopt -s nullglob
candidates=(
  "$HOME"/Library/Mobile\ Documents/com~apple~mail/Data/V*/MailData/Signatures/*.mailsignature
  "$HOME"/Library/Mail/V*/MailData/Signatures/*.mailsignature
)
if (( ${#candidates[@]} == 0 )); then
  echo "Nessuna firma trovata. Crea il segnaposto in Mail; se esiste già, dai al Terminale" >&2
  echo "l'Accesso completo al disco (Impostazioni di Sistema > Privacy e sicurezza)." >&2
  exit 1
fi
SIG="$(ls -t "${candidates[@]}" | head -1)"
echo "Firma da sostituire: $SIG"

mkdir -p "$DIR/backup"
cp "$SIG" "$DIR/backup/$(basename "$SIG").$(date +%Y%m%d-%H%M%S)"

export BASE_URL FACEBOOK_URL LINKEDIN_URL INSTAGRAM_URL WEBSITE_URL
BODY="$(sed -n '/<!-- SIGNATURE START -->/,/<!-- SIGNATURE END -->/p' "$DIR/signature.html" \
  | sed '/<!-- SIGNATURE /d' \
  | perl -pe '
      s{src="images/}{src="$ENV{BASE_URL}/images/}g;
      s/\{\{FACEBOOK_URL\}\}/$ENV{FACEBOOK_URL}/g;
      s/\{\{LINKEDIN_URL\}\}/$ENV{LINKEDIN_URL}/g;
      s/\{\{INSTAGRAM_URL\}\}/$ENV{INSTAGRAM_URL}/g;
      s/\{\{WEBSITE_URL\}\}/$ENV{WEBSITE_URL}/g;
    ')"

# Mantiene le intestazioni MIME del segnaposto (fino alla prima riga vuota) e sostituisce il corpo.
HEADER="$(awk '/^$/ { exit } { print }' "$SIG")"
chflags nouchg "$SIG"
{
  printf '%s\n\n' "$HEADER"
  printf '<body style="overflow-wrap: break-word; -webkit-nbsp-mode: space; line-break: after-white-space;">\n%s\n</body>' "$BODY"
} > "$SIG"
# Blocca il file, altrimenti Mail lo riscrive con la versione del segnaposto.
chflags uchg "$SIG"

echo "Fatto. Riapri Mail: la firma è in Impostazioni > Firme."
