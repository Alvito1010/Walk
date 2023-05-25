//
//  VersusView.swift
//  TryHealthKit
//
//  Created by Alvito . on 23/05/23.
//

import SwiftUI
import UserNotifications

struct VersusView: View {
    
    @EnvironmentObject var vm: HealthKitViewModel
    @EnvironmentObject var writevm: WriteViewModel
    @EnvironmentObject var readvm: ReadViewModel
    @State private var remainingTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var didWin: Bool = false
    @State private var didLose: Bool = false
    @State private var isButtonPressed = false
    @GestureState private var isLongPressing = false
    @State private var goToContentView = false


    
    
    var body: some View {
        NavigationView {
            if didWin {
                VStack {
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.15)
                    Text("You Win!").font(.custom("PressStart2P-Regular", size: 40))
                        .foregroundColor(Color(hex: 0xF7B500))
                    
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.1)
                    
                    Image("trophy").resizable().frame(width: UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.height * 0.35)
                    
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.1)
                    
                    Button(action: {
                        // Button action code goes here (if needed)
                        goToContentView = true
                        
                    }) {
                        Image(isLongPressing ? "winButton2" : "winButton1")
                            .resizable()
                            .frame(width: 250, height: 110).padding()
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                isButtonPressed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isButtonPressed = false
                                }
                            }
                    )
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.2)
                            .updating($isLongPressing) { value, state, _ in
                                state = value
                            }
                            .onEnded { _ in
                                // Long press ended, perform action if needed
                            }
                    )
                    NavigationLink(destination: ContentView(), isActive: $goToContentView) {
                        EmptyView()
                    }
                    
                    Spacer()
                }
            } else if didLose {
                VStack {
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.15)
                    Text("You Lost!").font(.custom("PressStart2P-Regular", size: 40))
                        .foregroundColor(Color(hex: 0xE02020))
                    
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.1)
                    
                    Image("sad").resizable().frame(width: UIScreen.main.bounds.height * 0.45, height: UIScreen.main.bounds.height * 0.35)
                    
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.1)
                    
                    Button(action: {
                        // Button action code goes here (if needed)
                        goToContentView = true
                        
                    }) {
                        Image(isLongPressing ? "loseButton2" : "loseButton1")
                            .resizable()
                            .frame(width: 250, height: 110).padding()
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                isButtonPressed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isButtonPressed = false
                                }
                            }
                    )
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.2)
                            .updating($isLongPressing) { value, state, _ in
                                state = value
                            }
                            .onEnded { _ in
                                // Long press ended, perform action if needed
                            }
                    )
                    NavigationLink(destination: ContentView(), isActive: $goToContentView) {
                        EmptyView()
                    }
                    
                    Spacer()
                }
            } else {
                VStack {
                    VStack(alignment: .leading) {
                        ZStack(alignment: .leading) {
                            Image("nameTileBlue")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08)
                            Text(getUsername())
                                .font(.custom("Futura-Bold", size: 32))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .padding()
                        }
                        Text(formatStepCount(vm.userStepCount))
                            .font(.custom("PressStart2P-Regular", size: 46))
                            .foregroundColor(Color(hex: 0x32C5FF))
                            .multilineTextAlignment(.leading)
                            .padding()
                        Text("Steps")
                            .font(.custom("PressStart2P-Regular", size: 36))
                            .foregroundColor(Color(hex: 0x32C5FF))
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Image("pixelLine")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.12)
                        Image("timerFrame")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.12)
                        Text(formatTime(remainingTime))
                            .font(.custom("PressStart2P-Regular", size: 32))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Steps")
                            .font(.custom("PressStart2P-Regular", size: 36))
                            .foregroundColor(Color(hex: 0xE02020))
                            .multilineTextAlignment(.trailing)
                            .padding()
                        if readvm.value != nil {
                            Text("\(readvm.value!)")
                                .font(.custom("PressStart2P-Regular", size: 46))
                                .foregroundColor(Color(hex: 0xE02020))
                                .multilineTextAlignment(.trailing)
                                .padding()
                        } else {
                            Text("0")
                                .font(.custom("PressStart2P-Regular", size: 46))
                                .foregroundColor(Color(hex: 0xE02020))
                                .multilineTextAlignment(.trailing)
                                .padding()
                        }
                        ZStack(alignment: .trailing) {
                            Image("nameTileRed")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08)
                            Text(getFriendUsername())
                                .font(.custom("Futura-Bold", size: 32))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .padding()
                        }
                    }
                }
            }
            
            
        }.onAppear {
            vm.readStepsTakenToday()
            
            readvm.observeSteps(username: getFriendUsername())
            startTimer {
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                writevm.pushNewValue(username: getUsername(), steps: Int(vm.userStepCount) ?? 0)
            }
        }

        .onDisappear {
            stopTimer()
            goToContentView = false
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    private func getFriendUsername() -> String {
        let savedFriendUsername = UserDefaults.standard.string(forKey: "FriendUsername") ?? ""
        return savedFriendUsername
    }
    
    private func getUsername() -> String {
        let savedUsername = UserDefaults.standard.string(forKey: "Username") ?? ""
        return savedUsername
    }
    
    private func formatStepCount(_ stepCount: String) -> String {
        if let count = Int(stepCount) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: count)) ?? stepCount
        } else {
            return stepCount
        }
    }
    
    private func startTimer(completion: @escaping () -> Void) {
        stopTimer()
        
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        let targetTime = calendar.date(bySettingHour: 02, minute: 09, second: 0, of: today) ?? now
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let currentTime = Date()
            let remaining = targetTime.timeIntervalSince(currentTime)
            
            if remaining > 0 {
                remainingTime = remaining
                if remaining <= 600 { // 10 minutes
                    scheduleLocalNotification()
                }
            } else {
                stopTimer()
                completion() // Call the completion closure when the timer ends
                compareSteps()
            }
        }
    }


    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        return formatter.string(from: time) ?? "00:00:00"
    }
    
    private func compareSteps() {
        let yourSteps = Int(vm.userStepCount) ?? 0
        let friendSteps = readvm.value ?? 0
        
        if yourSteps > friendSteps {
            didWin = true
            increaseWins()
        } else if yourSteps < friendSteps {
            didLose = true
            increaseLosses()
        }
        
        if didWin {
            UserDefaults.standard.set(false, forKey: "IsPlaying")
        }
        if didLose {
            UserDefaults.standard.set(false, forKey: "IsPlaying")
        }
        
    }
    
    private func increaseWins() {
        let wins = UserDefaults.standard.integer(forKey: "wins")
        UserDefaults.standard.set(wins + 1, forKey: "wins")
    }

    private func increaseLosses() {
        let losses = UserDefaults.standard.integer(forKey: "losses")
        UserDefaults.standard.set(losses + 1, forKey: "losses")
    }
    
    private func scheduleLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error here.
                print("Notification authorization \(error.localizedDescription)")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Time's running out!"
        content.body = "Only 10 minutes left for the challenge!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TimerNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Handle the error here.
                print("Notification scheduling error \(error.localizedDescription)")
            }
        }
    }
}

