//
//  ContentView.swift
//  Test
//
//  Created by Artem Leschenko on 20.08.2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - For changing view
    @State var orientation = UIDevice.current.orientation
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    @State private var isActive = true
    @State private var openImage = false

    var body: some View {
        let screen = UIScreen.main.bounds.size
        ZStack {
            VStack {
                Image("Test1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: screen.height * 0.3, alignment: .leading)
                    .clipped()
                    .animation(.default, value: orientation) // For changing View
                
                HStack(spacing: 20) {
                    Button {
                        withAnimation {
                            isActive.toggle()
                        }
                    } label: {
                        Text(isActive ? "Unlock": "Lock")
                            .customTextArea()
                    }
                    
                    Button {
                        withAnimation {
                            openImage = true
                        }
                    } label: {
                        Text("Open from top")
                            .customTextArea()
                    }.disabled(!isActive)
                        .opacity(isActive ? 1: 0.5)
                }
                Spacer()
                
                Button {
                    print("Without any action in task")
                } label: {
                    Text("Open full")
                        .customTextArea()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
            .zIndex(1)
            
            if openImage {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    openImage = false
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundColor(.gray)
                                        .frame(height: 32)
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                }.padding(20)
                            }
                        }
                        Spacer()
                    }.background (
                        Image("Test1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screen.width, height: screen.height + 30, alignment: .leading)
                            .clipped())
                    .transition(.backslide)
                    .zIndex(2)

            }
            
        }.onReceive(orientationChanged) { _ in
            self.orientation = UIDevice.current.orientation
        }
    }
}

fileprivate extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .top),
            removal: .move(edge: .top))}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

fileprivate extension View {
    func customTextArea(radius: Bool = true) -> some View {
        return self
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .padding(.horizontal)
            .background(.blue)
            .cornerRadius(18)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.indigo, lineWidth: 3)
            }
    }
}

