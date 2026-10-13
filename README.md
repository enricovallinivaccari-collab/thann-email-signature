# Firma email THANN per Apple Mail

Dal Figma "THANN" (Signature, node 20:3).

- `signature.html`: la firma (HTML a tabelle compatibile con i client email). Aprila nel browser per vedere un'anteprima.
- `images/`: PNG @3x esportati dal Figma (logo, tagline e 4 fette della barra social). La barra è fatta di immagini con lo sfondo incluso perché la modalità scura di Mail ricolora gli sfondi HTML.
- `install.sh`: installa la firma in Apple Mail.

## 1. Pubblica le immagini su GitHub Pages

1. Su github.com/new crea un repository **pubblico**, ad esempio `thann-email-signature`.
2. Clicca "uploading an existing file", trascina la cartella `images` (e, se vuoi un'anteprima online, `signature.html`), poi "Commit changes".
3. Vai in Settings → Pages → Source: "Deploy from a branch", branch `main`, cartella `/ (root)` → Save.
4. Dopo circa un minuto `https://<utente>.github.io/thann-email-signature/images/logo.png` deve mostrare il logo.

## 2. Configura

In cima a `install.sh` imposta `BASE_URL` (es. `https://<utente>.github.io/thann-email-signature`) e i link di Facebook, LinkedIn, Instagram e del sito.

## 3. Crea una firma segnaposto in Mail

1. Mail → Impostazioni → Firme → seleziona l'account → `+` → chiamala "THANN" (il testo non conta).
2. Togli la spunta all'opzione sul font predefinito dei messaggi, sotto l'anteprima della firma.
3. Chiudi Mail con Cmd+Q.

## 4. Installa

```bash
bash ~/Documents/THANN/email-signature/install.sh
```

Lo script sostituisce la firma che si chiama "THANN" (`SIGNATURE_NAME` in `install.sh`), sia nella cartella firme di iCloud sia in quella locale. Ne salva una copia in `backup/` e blocca il file, così Mail non lo sovrascrive. Se dice che non trova firme, dai al Terminale l'Accesso completo al disco (Impostazioni di Sistema → Privacy e sicurezza) e riprova.

Riapri Mail e scegli la firma in un nuovo messaggio. Nell'anteprima delle Impostazioni le immagini possono apparire come riquadri vuoti: è normale, nel messaggio si caricano.

Per modifiche successive: cambia `signature.html` o i link, chiudi Mail e rilancia lo script.
