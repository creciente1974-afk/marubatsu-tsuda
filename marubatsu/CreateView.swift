//
//  CreateView.swift
//  marubatsu
//
//  Created by tsuda kazumi on 2025/11/08.
//

import SwiftUI

struct CreateView: View {

    @Binding var quizzesArray: [Quiz]
    @State private var questionText = ""
    @State private var selectedAnswer = "o"
    let answers = ["o", "x"]

    let storekey = "quiz"  //UserDefaultsのキーを定義

    var body: some View {
        NavigationStack {

            VStack {
                Text("問題文と回答を入力して、追加ボタンを押してください")
                    .foregroundStyle(.gray)
                    .padding()
                TextField(text: $questionText) {
                    Text("問題文を入力してください")
                }
                .padding()
                .textFieldStyle(.roundedBorder)

                Picker("解答", selection: $selectedAnswer) {
                    ForEach(answers, id: \.self) { answers in Text(answers)

                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 300)
                .padding()

                Button("追加") {
                    addQuiz(question: questionText, answer: selectedAnswer)
                }
                .padding()

                Button {
                    deleteAllQuizzes()  //  struct CreateView 直下の関数を呼び出し
                } label: {
                    Text("全削除")
                }
                .foregroundStyle(.red)
                .padding()

                Divider()  //区切り線
                quizListSection  //問題リスト

            }
        }
        .toolbar {
            EditButton()
        }
    }

    var quizListSection: some View {
        List {

            ForEach($quizzesArray, id: \.id) { $quiz in
                HStack {
                    Text(quiz.question)
                    Spacer()

                    Text(quiz.answer ? "〇" : "×")
                        .bold()
                        .foregroundStyle(quiz.answer ? .blue : .red)

                }
            }
            // スワイプ削除
            .onDelete(perform: deleteQuiz)
            // 並び替え
            .onMove(perform: moveQuiz)
        }
    }

    //  関数をstruct CreateViewの直下に移動・定義

    func addQuiz(question: String, answer: String) {
        if question.isEmpty {
            print("問題文が入力されていません")
            return
        }

        var savingAnswer = true

        switch answer {
        case "o":
            savingAnswer = true
        case "x":
            savingAnswer = false
        default:
            print("適切な答えが入ってません")
            break

        }
        let newQuiz = Quiz(question: question, answer: savingAnswer)

        var array: [Quiz] = quizzesArray
        array.append(newQuiz)

        saveQuizzes(array: array)
        questionText = ""  // 入力欄をクリア
    }

    //  スワイプ削除の処理
    func deleteQuiz(offsets: IndexSet) {
        quizzesArray.remove(atOffsets: offsets)
        saveQuizzes(array: quizzesArray)  //変更を保存
    }

    // 並び替えの処理
    func moveQuiz(source: IndexSet, destination: Int) {  // 引数名を修正 (souse -> source, Destination -> destination)
        quizzesArray.move(fromOffsets: source, toOffset: destination)
        saveQuizzes(array: quizzesArray)
    }

    // 共通保存処理
    func saveQuizzes(array: [Quiz]) {
        if let encodedQuizzes = try? JSONEncoder().encode(array) {
            UserDefaults.standard.setValue(encodedQuizzes, forKey: storekey)
            //@Binding変数を更新して、回答画面に最新のリストを反映させる
            quizzesArray = array
            print("データを保存しました。問題数: \(quizzesArray.count)")
        }
    }

    // 全削除の処理
    func deleteAllQuizzes() {
        quizzesArray.removeAll()
        UserDefaults.standard.removeObject(forKey: storekey)
        print("すべての問題を削除しました。")
    }
}

#Preview {

}
