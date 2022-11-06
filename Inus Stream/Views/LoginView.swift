//
//  LoginView.swift
//  Inus Stream
//
//  Created by Inumaki on 27.10.22.
//

import SwiftUI
import SwiftUIFontIcon

struct LoginView: View {
    
    @State var emailString: String = ""
    @State var passString: String = ""
    
    @State var navigate: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#ff16151A")
                
                VStack {
                    Image("mal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .padding(.top, 50)
                    
                    Text("Login to MyAnimeList to sync your anime watch list and sync it whenever you watch something new")
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .padding(.horizontal, 32)
                    
                    VStack(alignment: .leading) {
                        Text("Email")
                            .foregroundColor(Color(hex: "#ff999999"))
                            .padding(.leading, 20)
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .frame(height: 10)
                        
                        
                        ZStack {
                            Color(hex: "#ff1E222C")
                            
                            TextField("Enter your Email...", text: $emailString)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                        }
                        .frame(height: 50)
                        .cornerRadius(30)
                        .padding(.top, 0)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        Text("Password")
                            .foregroundColor(Color(hex: "#ff999999"))
                            .padding(.leading, 20)
                            .font(.subheadline)
                            .padding(.bottom, 0)
                            .frame(height: 10)
                        
                        
                        ZStack {
                            Color(hex: "#ff1E222C")
                            
                            SecureInputView("Enter your password...", text: $passString)
                                .padding(.horizontal, 20)
                                .foregroundColor(.white)
                                
                        }
                        .frame(height: 50)
                        .cornerRadius(30)
                        .padding(.top, 0)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    NavigationLink(destination: HomePage(), isActive: $navigate) {
                        ZStack {
                            Color(hex: "#ff3477F3")
                            
                            Text("LOGIN")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .frame(maxWidth: 160, maxHeight: 50)
                        .cornerRadius(10)
                        .padding(.top, 12)
                        .onTapGesture {
                            login()
                    }
                    }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .frame(width: 13, height: 2)
                        
                        Text("OR")
                            .foregroundColor(.white)
                            .bold()
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .frame(width: 13, height: 2)
                    }
                    .padding(.top, 22)
                    
                    HStack {
                        
                            ZStack {
                                Color(hex: "#ff29313E")
                                
                                Image("google_logo")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(30)
                        
                        Spacer()
                            .frame(maxWidth: 40)
                        
                        ZStack {
                            Color(hex: "#ff29313E")
                            
                            Image(systemName: "applelogo")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        
    }
    
    func login() {
        print("Login requested")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }.padding(.trailing, 32)

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}
