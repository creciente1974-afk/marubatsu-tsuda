//
//  ContentView.swift
//  marubatsu
//
//  Created by tsuda kazumi on 2025/11/08.
//

import SwiftUI

struct Quiz: Identifiable, Codable {
    var id = UUID()
    var question: String
    var answer: Bool
}

struct ContentView: View {
    let quizeExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true),
    ]

    @AppStorage("quiz") var quizzesData = Data()
    @State var quizzesArray: [Quiz] = []

    @State var currentQuestionNum: Int = 0
    @State var showingAlert = false
    @State var alertTitle = ""

    init() {
        if let decodedQuizzes = try? JSONDecoder().decode(
            [Quiz].self,
            from: quizzesData
        ) {
            _quizzesArray = State(initialValue: decodedQuizzes)
        }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in

                VStack {
                    Text(showQuestion())
                        .padding()
                        .frame(
                            width: geometry.size.width * 0.85,
                            alignment: .leading
                        )
                        .font(.system(size: 25, ))
                        .fontDesign(.rounded)
                        .background(.yellow)

                    Spacer()

                    HStack {
                        Button {
                            checkAnswer(yourAnswer: true)
                        } label: {
                            Text("o")
                        }
                        .frame(
                            width: geometry.size.width * 0.4,
                            height: geometry.size.width * 0.4
                        )  // 幅: ""、高さ:""
                        .font(.system(size: 100, weight: .bold))  // フォントサイズ: 100 ,太字
                        .foregroundStyle(.white)  // 文字の色: 白
                        .background(.red)  // 背景色: 赤

                        Button {
                            checkAnswer(yourAnswer: false)
                        } label: {
                            Text("x")
                        }
                        .frame(
                            width: geometry.size.width * 0.4,
                            height: geometry.size.width * 0.4
                        )  // 幅: 、高さ:
                        .font(.system(size: 100, weight: .bold))  // フォントサイズ: 100 ,太字
                        .foregroundStyle(.white)  // 文字の色: 白
                        .background(.blue)  // 背景色: 青

                    }
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .navigationTitle("マルバツクイズ")
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {}

                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {

                            CreateView(quizzesArray: $quizzesArray)
                                .navigationTitle("問題を作ろう")
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                        }
                    }
                }
                .onAppear {
                    // この画面が表示されるとき（「問題を作る」画面から戻ってきたときを含む）に、
                    // 現在の問題番号を0（1問目）にリセットします。
                    currentQuestionNum = 0
                }
            }
        }
    }
    func showQuestion() -> String {

        var question = "問題がありません！"

        if !quizzesArray.isEmpty {
            let quiz = quizzesArray[currentQuestionNum]
            question = quiz.question

        }
        return question
    }
    func checkAnswer(yourAnswer: Bool) {
        if quizzesArray.isEmpty { return }
        let quiz = quizzesArray[currentQuestionNum]

        let ans = quiz.answer
        if yourAnswer == ans {
            alertTitle = "正解"

            if currentQuestionNum + 1 < quizzesArray.count {
                currentQuestionNum += 1
            } else {
                currentQuestionNum = 0
            }

        } else {
            alertTitle = "不正解"
        }
        showingAlert = true

    }

}

#Preview {
    ContentView()
}
