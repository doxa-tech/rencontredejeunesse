import "@astrojs/react"
import React, { useState } from "react";
import HCaptcha from '@hcaptcha/react-hcaptcha';
import * as styles from "./ContactForm.module.scss"

export const ContactForm = () => {

  const CONTACT_EMAILS: { [key: string]: string } = {
    "order": "QGjjhQ33",
    "group_order": "QGjjhQ33",
    "bug": "QGjjhQ33",
    "general": "QGjjhQ33"
  }

  let formId = "QGjjhQ33"; // default form
  let submitting = false;
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [hToken, setToken] = useState("");

  const onSubmit = async (e) => {
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
        "Nom": name,
        "Message": message,
        "h-captcha-response": hToken,
      })
    });

    if (response.ok) {
      alert("Ton message a été envoyé !");
      setEmail("");
      setMessage("");
      setName("");
    } else {
      alert("Nous avons rencontré un problème lors de l'envoi du message.");
    }
  };

  const onCategoryChange = function (e) {
    formId = CONTACT_EMAILS[e.value];
  }

  return (
    <form id="contact-form" onSubmit={onSubmit}>

      <select name="Catégorie" onChange={onCategoryChange}>
        <option value="Commandes">Commandes</option>
        <option value="Commandes pour un groupe">Commande pour un groupe</option>
        <option value="Signaler un bug">Signaler un bug</option>
        <option value="Question générale">Question générale</option>
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
        name="email"
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