//
//  ContentView.swift
//  marubatsu
//
//  Created by tsuda kazumi on 2025/11/08.
//

import SwiftUI
struct Quiz: Identifiable,Codable {
    var id = UUID()
    var question: String
    var answer: Bool
}

struct ContentView: View {
    let quizeExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]
    @State var currentQuestionNum: Int = 0
    @State var showingAlert = false
    @State var alertTitle = ""
    
    var body: some View {
        GeometryReader{ geometry in
            
            
            VStack {
                Text(showQuestion())
                    .padding()
                    .frame(width: geometry.size.width * 0.85,alignment: .leading)
                    .font(.system(size: 25, ))
                    .fontDesign(.rounded)
                    .background(.yellow)
                
                Spacer()
                
                HStack{
                    Button {
                        checkAnswer(yourAnswer: true)
                    } label: {
                        Text("o")
                    }
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4) // 幅: ""、高さ:""
                    .font(.system(size: 100, weight: .bold)) // フォントサイズ: 100 ,太字
                    .foregroundStyle(.white) // 文字の色: 白
                    .background(.red) // 背景色: 赤
                    
                    Button {
                        checkAnswer(yourAnswer: false)
                    } label: {
                        Text("x")
                    }
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4) // 幅: 、高さ:
                    .font(.system(size: 100, weight: .bold)) // フォントサイズ: 100 ,太字
                    .foregroundStyle(.white) // 文字の色: 白
                    .background(.blue) // 背景色: 青
                    
                }
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK",role: .cancel){}
                
            }
        }
    }
    func showQuestion() -> String {
        let question = quizeExamples[currentQuestionNum].question
        return question
    }
    func checkAnswer(yourAnswer:  Bool) {
        let quiz = quizeExamples[currentQuestionNum]
        let ans = quiz.answer
        if yourAnswer == ans {
            alertTitle = "正解"
            
            if currentQuestionNum + 1 < quizeExamples.count {
                currentQuestionNum += 1
            } else {
                currentQuestionNum = 0
            }
            
            
        }else {
            alertTitle = "不正解"
        }
        showingAlert = true
        
    }
    
}


#Preview {
    ContentView()
}
