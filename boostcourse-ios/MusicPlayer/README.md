### implicitly unwrapped optional 사용상 주의

```swift
var player: AVAudioPlayer!
```

player 는 "implicitly unwrapped optional" AVAudioPlay 타입이다. nil 값을 가질 수 있으나, 사용할 때에는 forced unwrapping할 필요가 없다.

```swift
player?.play()
```

그러나 사용 시점에 optional chaing으로 대체한 이유는 player에 객체를 할당하는 initAudioPlayer() method의 예외처리 과정에서 객체 할당을 하지 못할 수가 있기 때문이다. 사용 시점에 forced unwrapping하지 않아도 되는 편리함이 있지만, 정말 nil값이 아닌지 유의할 필요가 있다.



### AVAudioPlayer의 재생 완료 event delegate

AVAudioPlayerDelegate protocol를 채택하여 audioPlayerDidFinishPlaying(_:successfully) method를 구현하면 AVAudioPlayer 객체의 재생이 끝날 때, 이벤트를 처리할 수 있다.



### UISlider의 maximumValue property 

UISlider의 maximumValue 값을 아래와 같이 설정하여 default 값인 1을 사용할 때 "필요한 불필요한" 연산을 하지말자. 

```swift
slider.maximumValue = Float(player.duration)

slider.value = Float(player.currentTime)
player.currentTime = TimeInterval(slider.value)
```



### UIControl을 상속하는 하위 객체에서 touch event tracking

UISlider의 상위 클래스인 UIControl의 isTracking property를 사용하면, control이 touch event를 tracking하고 있는지 확인할 수 있다. 따라서 해당 변수를 이용하여 slider thumb 조작시 화면 갱신에 다른 로직을 반영할 수 있다.



### RunLoop와 함께 동작하는 Timer

Timer 는 RunLoop 와 함께 동작한다. xcode에서 single app 프로젝트를 생성하면 main thread를 포함한 각 thread에는 RunLoop 객체가 생성되고 따로 추가할 필요가 없다. Command Line Tool 프로젝트에서 Timer를 동작하려면 RunLoop를 동작시켜야 한다.



### Timer에서 closure의 capture list

class instance내부의 closure를 선언하여 self.variable 혹은 self.method() 에 접근한다면 해당 closure는 class instance를 강하게 참조하여 strong reference cycle이 생성된다. 이에 대한 해결책으로 closure의 정의부에 capture list를 선언한다. capture list를 통해 captured reference를 strong 대신 weak이나 unowned reference로 선언할 수 있게 된다. 객체를 unowned 로 참조하면 사용 시점에는 반드시 객체가 nil이 아니어야 하며, 만약에 객체가 nil이 된다면 런타임 에러가 발생한다. 이런 경우에는 weak로 참조해서 참조 객체를 optional chaining 방식으로 사용하든, nil 체크를 통해 안전하게 접근해야 된다.  

```swift
timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {
			[unowned self] timer in
			...
		}
timer.fire()
```

MusicPlayer의 Timer 실행 body에서 capture list로 self를 unowned reference로 선언하는데, controller 객체가 deallocate 될 경우가 있다면 deinit에서 timer.invalidate() 메소드를 호출하거나 weak 참조를 해야 안전하게 동작할 수 있다.