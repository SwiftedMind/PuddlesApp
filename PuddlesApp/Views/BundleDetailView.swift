//
//  Copyright © 2023 Dennis Müller and all collaborators
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI
import Puddles
import PreviewDebugTools

struct ThreadDetailView: View {
    let interface: Interface<Action>
    let state: ViewState

    var body: some View {
        switch state.thread {
        case .initial, .loading:
            ProgressView()
        case .failure:
            Text("Error")
        case .loaded(let thread):
            loadedContent(thread: thread)
                .animation(.default, value: thread)
                .animation(.default, value: state.isShowingComments)
        }
    }

    @ViewBuilder private func loadedContent(thread: Thread) -> some View {
        List {
            ThreadHeader(title: thread.title)
            ForEach(thread.items) { item in
                Section {
                    switch item.type {
                    case let .labeledImage(url, label):
                        Thread.ItemView.LabeledImage(url: url, label: label) {
                            interface.sendAction(.addRemarkTapped(item: item))
                        } onComment: {
                            interface.sendAction(.addCommentTapped(item: item))
                        }
                    case .fact(let fact):
                        Thread.ItemView.Fact(content: fact, remark: item.remarks.first) {
                            interface.sendAction(.addRemarkTapped(item: item))
                        } onComment: {
                            interface.sendAction(.addCommentTapped(item: item))
                        }
                    }
                }
            }
        }
    }
}

extension ThreadDetailView {
    struct ViewState {
        var thread: LoadingState<Thread, Error>
        var isShowingComments: Bool = true

        static var mock: ViewState {
            .init(thread: .loaded(.mock))
        }
    }

    enum Action {
        case something
        case addRemarkTapped(item: Thread.Item)
        case addCommentTapped(item: Thread.Item)
    }
}

struct ThreadDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Preview(ThreadDetailView.init, state: .mock) { action, $state in
                switch action {
                case .addRemarkTapped(item: let item):
                    var thread = state.thread.value
                    thread?.items[id: item.id]?.remarks.append(.init(content: "Another remark"))
                    state.thread = .loaded(thread!)
                default:
                    break
                }
            }
            .navigationTitle("Thread")
        }
        .preferredColorScheme(.dark)
    }
}
