import "@astrojs/react"
import { useEffect, useRef, useState } from "react";
import * as styles from "./Slideshow.module.scss"

export const SlideShow = ({ imagesFolder, numImages }) => {
  const [showModal, setShowModal] = useState(false);
  const [numbers, setNumbers] = useState(Array.from({ length: numImages }, (v, k) => k))
  const [modalImg, setModalImg] = useState(<></>)
  const current = useRef(0);
  const ref = useRef(null);
  numImages = parseInt(numImages, 10)

  const shuffleArray = (array: number[]) => {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  useEffect(() => {
    const a = Array.from({ length: numImages }, (v, k) => k)
    shuffleArray(a)
    setNumbers(a)
  }, [])

  // Focus / unfocus the modal to make key navigation work
  useEffect(() => {
    if (ref.current === null) {
      return
    }
    if (showModal) {
      ref.current.focus();
    } else {
      ref.current.blur();
    }
  }, [showModal])

  const plusSlide = (delta: number) => {
    current.current = (current.current + delta + numImages) % numImages
    setModalImg(
      <ModalImage value={numbers[current.current]} index={current.current} total={numImages} imagesFolder={imagesFolder} />
    )
  }

  const handleClick = (index: number) => {
    setModalImg(
      <ModalImage value={numbers[index]} index={index} total={numImages} imagesFolder={imagesFolder} />
    )
    setShowModal(true);
  }

  const handleKey = (e: KeyboardEventHandler) => {
    switch (e.key) {
      case 'ArrowLeft':
        plusSlide(-1)
        break;
      case 'ArrowRight':
        plusSlide(1)
    }
  }

  return (
    <>
      <div className={styles.images}>
        {numbers.map((value, index) =>
          <figure key={index.toString()} onClick={() => handleClick(index)}>
            <picture>
              <source type="image/webp" srcSet={`${imagesFolder}/small/${value}.jpg.webp`} />
              <img src={`${imagesFolder}/small/${value}.jpg`} className="slideshow small image" />
            </picture>
          </figure>
        )}
      </div>

      {showModal &&
        <div id="myModal" className={styles.modal} onKeyDown={handleKey} tabIndex={-1} ref={ref}>
          <span onClick={() => setShowModal(false)} className={styles.close}>&times;</span>
          <div className={styles.modalContent}>

            {modalImg}

            <a className={styles.prev} onClick={() => plusSlide(-1)}>&#10094;</a>
            <a className={styles.next} onClick={() => plusSlide(1)}>&#10095;</a>

            <div className={styles.captionContainer}>
              <p id="caption"></p>
            </div>
          </div>
        </div>
      }
    </>
  )
}

const ModalImage = ({ value, index, total, imagesFolder }) => (
  <div className={styles.mySlides}>
    <div className={styles.numbertext}>{index + 1} / {total}</div>
    <picture>
      <source type="image/webp" srcSet={`${imagesFolder}/${value}.jpg.webp`} />
      <img src={`${imagesFolder}/${value}.jpg`} />
    </picture>
  </div>
)