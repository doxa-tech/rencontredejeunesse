import "@astrojs/react"
import { useState } from "react";
import * as styles from "./HistoryReact.module.scss"

export const HistoryReact = () => {
  const [currentID, setCurrentID] = useState("1");

  return (
    <div className={styles.sectionContainer}>
      <div className={styles.timeline}>
        <div className={styles.wrapper}>
          <h2>histoire</h2>
          <ul>
            <HistBtn id="1" currentID={currentID} setCurrentID={setCurrentID}>
              1993
            </HistBtn>
            <HistBtn id="2" currentID={currentID} setCurrentID={setCurrentID}>
              Première RJ
            </HistBtn>
            <HistBtn id="3" currentID={currentID} setCurrentID={setCurrentID}>
              1994 & 1995
            </HistBtn>
            <HistBtn id="4" currentID={currentID} setCurrentID={setCurrentID}>
              1996 & 2010
            </HistBtn>
            <HistBtn id="5" currentID={currentID} setCurrentID={setCurrentID}>
              1998
            </HistBtn>
            <HistBtn id="6" currentID={currentID} setCurrentID={setCurrentID}>
              2005
            </HistBtn>
            <HistBtn id="7" currentID={currentID} setCurrentID={setCurrentID}>
              2011
            </HistBtn>
            <HistBtn id="8" currentID={currentID} setCurrentID={setCurrentID}>
              2012
            </HistBtn>
            <HistBtn id="9" currentID={currentID} setCurrentID={setCurrentID}>
              2015
            </HistBtn>
            <HistBtn id="10" currentID={currentID} setCurrentID={setCurrentID}>
              2020 & 2021
            </HistBtn>
            <HistBtn id="11" currentID={currentID} setCurrentID={setCurrentID}>
              2022
            </HistBtn>
            <HistBtn id="12" currentID={currentID} setCurrentID={setCurrentID}>
              Aujourd'hui
            </HistBtn>
          </ul>
        </div>
      </div>
      <div className={styles.show}>
        <HistEl id="1" currentID={currentID}>
          <h3>1993</h3>
          <p>
            La RJ est fondée et dirigée par le précieux homme de foi et regretté Jean Blanc. Il sera secondé rapidement par Olivier Zaugg.
          </p>
        </HistEl>

        <HistEl id="2" currentID={currentID}>
          <h3>1993</h3>
          <p>
            1re RJ à Orvin avec environ 150 jeunes.
          </p>
        </HistEl>

        <HistEl id="3" currentID={currentID}>
          <h3>1994 & 1995</h3>
          <p>
            2e et 3e RJ à Péry avec environ 300 jeunes.
          </p>
        </HistEl>

        <HistEl id="4" currentID={currentID}>
          <h3>1996 à 2010</h3>
          <p>
            La RJ se vit au Landeron, et le nombre de participants augmente chaque année par centaine.
          </p>
        </HistEl>

        <HistEl id="5" currentID={currentID}>
          <h3>1998</h3>
          <p>
            La RJ passe le cap des 1000 participants.
          </p>
        </HistEl>

        <HistEl id="6" currentID={currentID}>
          <h3>2005</h3>
          <p>
            Jean et Olivier passent le flambeau à une équipe d’amis qu’ils ont su lever à leurs côtés. Yves et Catherine Matthey, Blaise et Edith Thomi, Christophe Konrad, Christophe Monnot, David Guyaz, David Tripet, Christian Kuhn, Eddy Jeanneret.
          </p>
        </HistEl>

        <HistEl id="7" currentID={currentID}>
          <h3>2011</h3>
          <p>
            Grâce à son succès, la RJ émigre en terre fribourgeoise dans les locaux de l’Espace Gruyère à Bulle. Elle passe le cap des 1500 participants.
          </p>
        </HistEl>

        <HistEl id="8" currentID={currentID}>
          <h3>2012</h3>
          <p>
            Le cap des 2000 participants est franchi.
          </p>
        </HistEl>

        <HistEl id="9" currentID={currentID}>
          <h3>2015</h3>
          <p>
            Le cap des 3000 participants est franchi.
          </p>
        </HistEl>

        <HistEl id="10" currentID={currentID}>
          <h3>2020 & 2021</h3>
          <p>
            RJ en ligne
          </p>
        </HistEl>

        <HistEl id="11" currentID={currentID}>
          <h3>2022</h3>
          <p>
            Première RJ en multi-sites.
          </p>
        </HistEl>

        <HistEl id="12" currentID={currentID}>
          <h3>Aujourd'hui</h3>
          <p>
            Aujourd’hui, la RJ est à l’étroit à Bulle et des projets d’agrandissement sont à l’étude. La RJ est organisée par une équipe d’ami/es qui sont tous/tes engagés/es dans différentes églises locales de Suisse romande. Elle accueille des jeunes de plus de 10 fédérations d’églises différentes.<br />
            Durant toutes ces années, la RJ a permis à :
            <ul>
              <li>des centaines de jeunes de donner leur vie à Jésus. (Certains pasteurs actuels en Suisse romande ont rencontré Jésus à la RJ.)</li>
              <li>des centaines de jeunes de vivre des guérisons physiques</li>
              <li>des centaines de jeunes d’être baptisés du Saint-Esprit</li>
              <li>des centaines de jeunes de vivre des délivrances</li>
              <li>des centaines de jeunes de recevoir des appels précis pour leur vie</li>
              <li>des milliers de jeunes d’être encouragés dans leur foi… </li>
            </ul>
            L’aventure continue…
          </p>
        </HistEl>
      </div>
    </div>
  )
}

const HistEl = ({ currentID, id, children }) => {
  return (
    (currentID === id ? <div className={`${styles.content} ${id == 12 ? styles.bigger : ''}`} > {children}</div > : <></>)
  )
}

const HistBtn = ({ id, currentID, setCurrentID, children }) => {
  const clickHandler = () => {
    setCurrentID(id)
  }

  return (
    <li>
      <p onClick={clickHandler} className={currentID === id ? styles.selected : styles.arrow}>
        <span className={styles.arrow}>⎯⎯</span>
        {children}
        <span className={styles.link}></span>
      </p>
    </li>
  )
}