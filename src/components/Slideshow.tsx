import React, { useEffect, useRef, useState } from "react";
import styles from "./Slideshow.module.scss"

interface SlideShowProps {
  imagesFolder: string;
  numImages: number;
}

interface ModalImageProps {
  value: number;
  index: number;
  total: number;
  imagesFolder: string;
}

const shuffleArray = (array: number[]) => {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    const temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}

export const SlideShow = ({ imagesFolder, numImages }: SlideShowProps) => {
  const [showModal, setShowModal] = useState(false);
  const [numbers, setNumbers] = useState(Array.from({ length: numImages }, (_, k) => k))
  const [currentIndex, setCurrentIndex] = useState(0);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const a = Array.from({ length: numImages }, (_, k) => k)
    shuffleArray(a)
    setNumbers(a)
  }, [])

  // Focus the modal on open to enable keyboard navigation
  useEffect(() => {
    if (showModal) ref.current?.focus({ preventScroll: true });
  }, [showModal])

  const plusSlide = (delta: number) => {
    setCurrentIndex(prev => (prev + delta + numImages) % numImages);
  }

  const handleClick = (index: number) => {
    setCurrentIndex(index);
    setShowModal(true);
  }

  const handleKey = (e: React.KeyboardEvent<HTMLDivElement>) => {
    if (e.key === 'ArrowLeft') plusSlide(-1);
    else if (e.key === 'ArrowRight') plusSlide(1);
  }

  return (
    <>
      <div className={styles.images}>
        {numbers.map((value, index) =>
          <figure key={index.toString()} onClick={() => handleClick(index)}>
            <picture>
              <source type="image/webp" srcSet={`${imagesFolder}/small/${value}.jpg.webp`} />
              <img src={`${imagesFolder}/small/${value}.jpg`} />
            </picture>
          </figure>
        )}
      </div>

      {showModal &&
        <div className={styles.modal} onKeyDown={handleKey} tabIndex={-1} ref={ref}>
          <span onClick={() => setShowModal(false)} className={styles.close}>&times;</span>
          <div className={styles.modalContent}>
            <ModalImage value={numbers[currentIndex]} index={currentIndex} total={numImages} imagesFolder={imagesFolder} />
            <a className={styles.prev} onClick={() => plusSlide(-1)}>&#10094;</a>
            <a className={styles.next} onClick={() => plusSlide(1)}>&#10095;</a>
          </div>
        </div>
      }
    </>
  )
}

const ModalImage = ({ value, index, total, imagesFolder }: ModalImageProps) => (
  <div className={styles.mySlides}>
    <div className={styles.numbertext}>{index + 1} / {total}</div>
    <picture>
      <source type="image/webp" srcSet={`${imagesFolder}/${value}.jpg.webp`} />
      <img src={`${imagesFolder}/${value}.jpg`} />
    </picture>
  </div>
)
