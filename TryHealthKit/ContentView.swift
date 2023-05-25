//
//  ContentView.swift
//  TryHealthKit
//
//  Created by Alvito . on 05/05/23.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var vm: HealthKitViewModel
    @EnvironmentObject var writevm: WriteViewModel
    @EnvironmentObject var readvm: ReadViewModel
    @State private var showUsernameSheet = !UserDefaults.standard.bool(forKey: "UsernameSaved")
    @State private var showFriendUsernameSheet = false
    @State private var usernameInput: String = ""
    @State private var friendUsernameInput: String = ""
    @State private var isButtonPressed = false
    @GestureState private var isLongPressing = false
    @State private var goToVersusView = false
    @State private var errorMsg = ""

    var body: some View {
        Group{
            if UserDefaults.standard.bool(forKey: "IsPlaying") {
                        VersusView()
            } else {
               NavigationView {
                    VStack {
                        if vm.isAuthorized {
                            VStack {
                                HStack {
                                    Text("Hello \(getUsername())!")
                                        .font(.custom("Futura-Bold", size: 36))
                                        .padding()
                                    
                                    Spacer()
                                    Button(action: {
                                        vm.readStepsTakenToday()
                                    }) {
                                        Image(systemName: "arrow.counterclockwise")
                                            .font(.system(size: 25))
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                }
                                Spacer().frame(height: UIScreen.main.bounds.height * 0.1)
                                Text("Steps Taken Today")
                                    .font(.custom("Futura-Medium", size: 32))
                                Spacer().frame(height: UIScreen.main.bounds.height * 0.02)
                                Text(vm.userStepCount)
                                    .font(.custom("PressStart2P-Regular", size: 44))
                                    .foregroundColor(Color(hex: 0xfb6322))
                                HStack {
                                    VStack {
                                        Text("Wins")
                                            .font(.custom("Futura-Medium", size: 32))
                                        Text("\(UserDefaults.standard.integer(forKey: "wins"))")
                                            .font(.custom("PressStart2P-Regular", size: 44))
                                            .foregroundColor(Color(hex: 0xfb6322))
                                            .padding()
                                    }
                                    .padding(.trailing)
                                    VStack {
                                        Text("Losses")
                                            .font(.custom("Futura-Medium", size: 32))
                                        Text("\(UserDefaults.standard.integer(forKey: "losses"))")
                                            .font(.custom("PressStart2P-Regular", size: 44))
                                            .foregroundColor(Color(hex: 0xfb6322))
                                            .padding()
                                    }
                                    .padding(.leading)
                                }
                                Spacer().frame(height: UIScreen.main.bounds.height * 0.1)
                                Text("Wanna prove yourself?")
                                    .font(.custom("Futura-Medium", size: 22))
                                Text("Invite your friends!")
                                    .font(.custom("Futura-Bold", size: 22))
                                Button(action: {
                                    // Button action code goes here (if needed)
                                    showFriendUsernameSheet.toggle()
                                    writevm.pushNewValue(username: getUsername(), steps: Int(vm.userStepCount) ?? 0)
                                }) {
                                    Image(isLongPressing ? "pixelPlay2" : "pixelPlay")
                                        .resizable()
                                        .frame(width: 250, height: 110)
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
                            }
                        } else {
                            VStack {
                                Text("Please Authorize Health!")
                                    .font(.title3)
                                Button {
                                    vm.healthRequest()
                                } label: {
                                    Text("Authorize HealthKit")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 320, height: 55)
                                .background(Color(.orange))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .onAppear {
                        vm.readStepsTakenToday()
                        //writevm.createPath(username: usernameInput, steps: Int(vm.userStepCount) ?? 77)
                    }
                    .sheet(isPresented: $showUsernameSheet) {
                        // Sheet content for entering username
                        VStack {
                            Text("Enter your username")
                            TextField("Username", text: $usernameInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            HStack {
                                Spacer()
                                Button("OK") {
                                    if usernameInput.count < 3{
                                        errorMsg = "please input more than 2 characters!"
                                    } else {
                                        errorMsg = ""
                                        vm.readStepsTakenToday()
                                        saveUsername()
                                        writevm.pushNewValue(username: usernameInput, steps: Int(vm.userStepCount) ?? 0)
                                        setStatusNotPlaying()
                                        showUsernameSheet = false
                                    }
                                    
                                }.padding()
                            }
                            Text(errorMsg).foregroundColor(.red)
                        }
                        .presentationDetents([.large, .medium, .fraction(0.75)])
                    }
                    .onAppear {
                        vm.readStepsTakenToday()
                    }
                    .sheet(isPresented: $showFriendUsernameSheet) {
                        // Sheet content for entering username
                        VStack {
                            Text("Enter your friend's username")
                            TextField("Username", text: $friendUsernameInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            HStack {
                                Spacer()
                                Button("Cancel") {
                                    showFriendUsernameSheet = false
                                }.padding()
                                Button("OK") {
                                    if friendUsernameInput.count < 3 {
                                        errorMsg = "please input more than 2 characters!"
                                    } else {
                                        errorMsg = ""
                                        saveFriendUsername()
                                        showFriendUsernameSheet = false
                                        setStatusPlaying()
                                        goToVersusView = true
                                    }
                                    
                                }.padding()
                            }
                            Text(errorMsg).foregroundColor(.red)
                        }
                        .presentationDetents([.large, .medium, .fraction(0.75)])
                    }
                    .background(
                        NavigationLink(destination: VersusView(), isActive: $goToVersusView) {
                            EmptyView()
                        }
                    )
                    .navigationBarHidden(true)
                }
            }
        }.onAppear {
            // Set the initial value of "IsPlaying" to false if it doesn't exist
            if UserDefaults.standard.object(forKey: "IsPlaying") == nil {
                UserDefaults.standard.set(false, forKey: "IsPlaying")
            }
        }
        
    }

    private func saveUsername() {
        UserDefaults.standard.set(usernameInput, forKey: "Username")
        UserDefaults.standard.set(true, forKey: "UsernameSaved")
        UserDefaults.standard.set(0, forKey: "wins")
        UserDefaults.standard.set(0, forKey: "losses")

    }

    private func getUsername() -> String {
        let savedUsername = UserDefaults.standard.string(forKey: "Username") ?? ""
        return savedUsername
    }
    
    private func saveFriendUsername() {
        UserDefaults.standard.set(friendUsernameInput, forKey: "FriendUsername")
    }
    
    private func getFriendUsername() -> String {
        let savedFriendUsername = UserDefaults.standard.string(forKey: "FriendUsername") ?? ""
        return savedFriendUsername
    }
    
    private func setStatusNotPlaying(){
        UserDefaults.standard.set(false, forKey: "IsPlaying")
    }
    
    private func setStatusPlaying(){
        UserDefaults.standard.set(true, forKey: "IsPlaying")
    }
    
    private func setWins(){
        UserDefaults.standard.set(0, forKey: "wins")
    }
    
    private func setLosses(){
        UserDefaults.standard.set(0, forKey: "wins")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HealthKitViewModel())
            .environmentObject(WriteViewModel())
            .environmentObject(ReadViewModel())
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double(hex & 0xff) / 255
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}
