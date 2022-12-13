import "@astrojs/react"
import { useEffect, useRef, useState } from "react";

export const SlideShow = () => {
  const [showModal, setShowModal] = useState(false);
  const [numbers, setNumbers] = useState(Array.from({ length: 20 }, (v, k) => k))
  const [modalImg, setModalImg] = useState(<></>)
  const current = useRef(0);
  const ref = useRef(null);

  const shuffleArray = (array: number[]) => {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }

  useEffect(() => {
    const a = Array.from({ length: 20 }, (v, k) => k)
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
    current.current = (current.current + delta + 20) % 20
    setModalImg(
      <ModalImage value={numbers[current.current]} index={current.current} total={20} />
    )
  }

  const handleClick = (index: number) => {
    setModalImg(
      <ModalImage value={numbers[index]} index={index} total={20} />
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
      <div className="images">
        {numbers.map((value, index) =>
          <figure key={index.toString()} onClick={() => handleClick(index)}>
            <picture>
              <source type="image/webp" srcSet={`/highlights/top20/images/small/${value}.jpg.webp`} />
              <img src={`highlights/19/top20/images/small/${value}.jpg`} className="slideshow small image" />
            </picture>
          </figure>
        )}
      </div>

      {showModal &&
        <div id="myModal" className="modal" onKeyDown={handleKey} tabIndex={-1} ref={ref}>
          <span onClick={() => setShowModal(false)} className="slideshow close cursor">&times;</span>
          <div className="modal-content">

            {modalImg}

            <a className="slideshow prev" onClick={() => plusSlide(-1)}>&#10094;</a>
            <a className="slideshow next" onClick={() => plusSlide(1)}>&#10095;</a>

            <div className="caption-container">
              <p id="caption"></p>
            </div>
          </div>
        </div>
      }
    </>
  )
}

const ModalImage = ({ value, index, total }) => (
  <div className="mySlides">
    <div className="numbertext">{index + 1} / {total}</div>
    <picture>
      <source type="image/webp" srcSet={`/highlights/top20/images/${value}.jpg.webp`} />
      <img src={`/highlights/top20/images/${value}.jpg`} className="slideshow big image" />
    </picture>
  </div>
)