//
//  Window player.swift
//  Lesson 6 UISlider - Player
//
//  Created by Валентин Ремизов on 20.01.2023.
//

import UIKit
import AVFoundation

class Window_player: UIViewController {
//MARK: - Property
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet weak var playPauseImgView: UIImageView!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var hideImgView: UIImageView!
    @IBOutlet weak var shareImgView: UIImageView!
    @IBOutlet weak var nextImgView: UIImageView!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var repeatImgView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var randomImgView: UIImageView!

    var repeatBool = false
    var image = UIImage()
    let artistLabel = UILabel()
    var trackLabel = UILabel()
    private let trackVremena = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Vremena", ofType: "mp3") ?? ""))
    private let trackOptimist = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Optimist", ofType: "mp3") ?? ""))
    private let trackKaif = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Kaif", ofType: "mp3") ?? ""))
    var arrayTracks = [AVAudioPlayer]()
    var soundOutlet = AVAudioPlayer()
    var indexSound = Int()


//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayTracks = [trackVremena, trackOptimist, trackKaif]
        currentImageView.image = image
        artistLabel.frame = CGRect(x: 95, y: 501, width: 200, height: 21)
        artistLabel.textAlignment = .center
        artistLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 25.0)
        trackLabel.frame = CGRect(x: 95, y: 530, width: 200, height: 21)
        trackLabel.textAlignment = .center
        trackLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18.0)
        view.addSubview(artistLabel)
        view.addSubview(trackLabel)

//MARK: - Слайдер Duration
        //Меняет текущее положение песни по передвижению слайдера
        durationSlider.addTarget(self, action: #selector(editingDuration), for: .valueChanged)
        durationSlider.minimumValue = 0.0
        durationSlider.maximumValue = Float(soundOutlet.duration)
        //Меняет текущее положение слайдера по времени песни
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        //Назначает просто другой кружочек ползунку слайдера
        durationSlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        durationSlider.tintColor = .blue


//MARK: - Кнопка Play/Pause
        let tapPlayPause = UITapGestureRecognizer(target: self, action: #selector(tapPlayPause))
        //Делаем нашу картинку интерактивной и возможной для взаимодействия
        playPauseImgView.isUserInteractionEnabled = true
        //Назначаем нашей кнопке строчку со ссылкой на необходимое действие при нажатии (аналог addTarget)
        playPauseImgView.addGestureRecognizer(tapPlayPause)

//MARK: - Кнопка Hide (закрытие окна)
        let tapHide = UITapGestureRecognizer(target: self, action: #selector(tapHidePressed))
        hideImgView.isUserInteractionEnabled = true
        hideImgView.addGestureRecognizer(tapHide)

//MARK: - Кнопка Share (поделиться) - делал по этому видео (https://www.youtube.com/watch?v=do1EF3CoO8M)
        let tapShare = UITapGestureRecognizer(target: self, action: #selector(tapShare))
        shareImgView.isUserInteractionEnabled = true
        shareImgView.addGestureRecognizer(tapShare)

//MARK: - Кнопка Next/Back
        let tapNext = UITapGestureRecognizer(target: self, action: #selector(nextPressed))
        nextImgView.isUserInteractionEnabled = true
        nextImgView.addGestureRecognizer(tapNext)
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(backPressed))
        backImgView.isUserInteractionEnabled = true
        backImgView.addGestureRecognizer(tapBack)

//MARK: - Кнопка Repeat
        let tapRepeat = UITapGestureRecognizer(target: self, action: #selector(repeatPressed))
        repeatImgView.isUserInteractionEnabled = true
        repeatImgView.addGestureRecognizer(tapRepeat)

//MARK: - Кнопка Random
        let tapRandom = UITapGestureRecognizer(target: self, action: #selector(randomPressed))
        randomImgView.isUserInteractionEnabled = true
        randomImgView.addGestureRecognizer(tapRandom)
    }


//MARK: - Functions
    @objc @IBAction func editingDuration(_ sender: Any) {
        soundOutlet.currentTime = TimeInterval(durationSlider.value)
        //Если ползунок выйдет за рамки мин или макс, то он установит крайнее значение мин или макс
        durationSlider.setValue(Float(soundOutlet.currentTime), animated: true)
    }

    @objc func updateTime() {
        //Вот этой строчкой мы заставляем слайдер повторять текущее время песни в реал тайм!
        durationSlider.value = Float(soundOutlet.currentTime)

        let minutes = Int(soundOutlet.currentTime / 60)
        let seconds = Int(soundOutlet.currentTime.truncatingRemainder(dividingBy: 60))
        currentTimeLabel.text = NSString(format: "%02d:%02d", minutes, seconds) as String

        let endTime = soundOutlet.currentTime - soundOutlet.duration
        let minutesEnd = Int(endTime / 60)
        let secondsEnd = Int(-endTime.truncatingRemainder(dividingBy: 60))
        endTimeLabel.text = NSString(format: "%02d:%02d", minutesEnd, secondsEnd) as String
    }

    @objc func tapPlayPause (sender: UITapGestureRecognizer) {
        guard sender.view is UIImageView else {return}
        if soundOutlet.isPlaying == true {
            soundOutlet.pause()
            //При нажатии меняем картинку с play на pause
            playPauseImgView.image = UIImage(systemName: "play.fill")
        } else {
            soundOutlet.play()
            playPauseImgView.image = UIImage(systemName: "pause.fill")
        }
    }

    @objc func tapHidePressed (sender: UITapGestureRecognizer) {
        soundOutlet.stop()
        dismiss(animated: true)
    }

    @objc func tapShare (sender: UITapGestureRecognizer) {
        let activityControl = UIActivityViewController(activityItems: ["Hi, this song is cool"], applicationActivities: nil)
        activityControl.popoverPresentationController?.sourceView = view

        present(activityControl, animated: true)
    }

    @objc func nextPressed (sender: UITapGestureRecognizer) {
        backImgView.tintColor = .black
        soundOutlet.stop()

        //Включает рандомные песни
        if randomImgView.tintColor == .blue {
            indexSound = .random(in: 0...2)
        } else {
            indexSound += 1
        }

        //Включает повтор по кругу песен
        if repeatBool == true && indexSound > 2 {
            indexSound = 0
            soundOutlet = arrayTracks[indexSound]
            switch indexSound {
            case 0: currentImageView.image = UIImage(named: "Альбом 1"); trackLabel.text = "Времена"
            case 1: currentImageView.image = UIImage(named: "Альбом 2"); trackLabel.text = "Оптимист"
            default: currentImageView.image = UIImage(named: "Альбом 3"); trackLabel.text = "Жить в кайф"
            }
            soundOutlet.play()
        } else if repeatBool == false && indexSound > 2 {
            indexSound = 2
            soundOutlet = arrayTracks[indexSound]
            switch indexSound {
            case 0: currentImageView.image = UIImage(named: "Альбом 1"); trackLabel.text = "Времена"
            case 1: currentImageView.image = UIImage(named: "Альбом 2"); trackLabel.text = "Оптимист"
            default: currentImageView.image = UIImage(named: "Альбом 3"); trackLabel.text = "Жить в кайф"
            }
            soundOutlet.stop()
            nextImgView.tintColor = .systemGray2
        } else {
            soundOutlet = arrayTracks[indexSound]
            switch indexSound {
            case 0: currentImageView.image = UIImage(named: "Альбом 1"); trackLabel.text = "Времена"
            case 1: currentImageView.image = UIImage(named: "Альбом 2"); trackLabel.text = "Оптимист"
            default: currentImageView.image = UIImage(named: "Альбом 3"); trackLabel.text = "Жить в кайф"
            }
            soundOutlet.play()
        }
    }

    @objc func backPressed (sender: UITapGestureRecognizer) {
        nextImgView.tintColor = .black
        soundOutlet.stop()

        //Включает рандомные песни
        if randomImgView.tintColor == .blue {
            indexSound = .random(in: 0...2)
        } else {
            indexSound -= 1
        }

        //Включает повтор по кругу песен
        if repeatBool == true && indexSound < 0 {
            indexSound = 2
            soundOutlet = arrayTracks[indexSound]
            switch indexSound {
            case 0: currentImageView.image = UIImage(named: "Альбом 1"); trackLabel.text = "Времена"
            case 1: currentImageView.image = UIImage(named: "Альбом 2"); trackLabel.text = "Оптимист"
            default: currentImageView.image = UIImage(named: "Альбом 3"); trackLabel.text = "Жить в кайф"
            }
            soundOutlet.play()
        } else if repeatBool == false && indexSound < 0 {
            indexSound = 0
            soundOutlet = arrayTracks[indexSound]
            switch indexSound {
            case 0: currentImageView.image = UIImage(named: "Альбом 1"); trackLabel.text = "Времена"
            case 1: currentImageView.image = UIImage(named: "Альбом 2"); trackLabel.text = "Оптимист"
            default: currentImageView.image = UIImage(named: "Альбом 3"); trackLabel.text = "Жить в кайф"
            }
            soundOutlet.stop()
            backImgView.tintColor = .systemGray2
        } else {
            soundOutlet = arrayTracks[indexSound]
            switch indexSound {
            case 0: currentImageView.image = UIImage(named: "Альбом 1"); trackLabel.text = "Времена"
            case 1: currentImageView.image = UIImage(named: "Альбом 2"); trackLabel.text = "Оптимист"
            default: currentImageView.image = UIImage(named: "Альбом 3"); trackLabel.text = "Жить в кайф"
            }
            soundOutlet.play()
        }
    }

    @objc func repeatPressed (sender: UITapGestureRecognizer) {
        if repeatBool == true {
            repeatBool = false
            repeatImgView.tintColor = .systemGray2
        } else {
            repeatBool = true
            repeatImgView.tintColor = .blue
            nextImgView.tintColor = .black
            backImgView.tintColor = .black
        }
    }

    @objc func randomPressed (sender: UITapGestureRecognizer) {
        if randomImgView.tintColor == .blue {
            randomImgView.tintColor = .systemGray2
        } else {
            randomImgView.tintColor = .blue
        }
    }
}
