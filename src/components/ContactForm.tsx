import "@astrojs/react"
import { ChangeEvent, FormEvent, useState } from "react";
import HCaptcha from '@hcaptcha/react-hcaptcha';
import * as styles from "./ContactForm.module.scss"

export const ContactForm = () => {

  const CONTACT_EMAILS: { [key: string]: string } = {
    "order": "QGjjhQ33",
    "bug": "QGjjhQ33",
    "general": "QGjjhQ33"
  }

  let formId = "QGjjhQ33"; // default form
  let submitting = false;
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [subject, setSubject] = useState("");
  const [message, setMessage] = useState("");
  const [hToken, setToken] = useState("");

  const onSubmit = async (e: FormEvent) => {
    e.preventDefault();
    submitting = true;
    // send
    let response = await fetch("https://submit-form.com/" + formId, {
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({
        "email": email,
        "_email.from": name,
        "_email.subject": subject,
        "message": message,
        "h-captcha-response": hToken,
      })
    });

    if (response.ok) {
      alert("Ton message a été envoyé !");
      setEmail("");
      setMessage("");
      setName("");
      setSubject("");
    } else {
      alert("Nous avons rencontré un problème lors de l'envoi du message.");
    }
  };

  const onCategoryChange = function (e: ChangeEvent<HTMLSelectElement>) {
    console.log(e.target.value)
    formId = CONTACT_EMAILS[e.target.value];
  }

  return (
    <form id="contact-form" onSubmit={onSubmit}>

      <select name="Catégorie" onChange={onCategoryChange}>
        <option value="order">Commandes</option>
        <option value="bug">Signaler un bug</option>
        <option value="general">Question générale</option>
      </select>

      <input
        placeholder="Nom"
        required
        type="text"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />

      <input
        placeholder="Email"
        required
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />

      <input
        placeholder="Sujet"
        required
        type="text"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />

      <textarea
        placeholder="Message"
        cols="30"
        rows="10"
        required
        name="Message"
        value={message}
        onChange={(e) => setMessage(e.target.value)}
      />

      <div className={styles.hCaptcha}>
        <HCaptcha
          sitekey="b4753cb9-88e5-4594-bda2-ad5a0aab862c"
          onVerify={(token, _) => setToken(token)}
        />
      </div>

      <div className={styles.input}>
        <button type="submit" disabled={submitting || hToken == ""}>Envoyer</button>
      </div>
    </form>
  );
};