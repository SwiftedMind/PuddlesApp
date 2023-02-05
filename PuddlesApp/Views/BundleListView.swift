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

struct ThreadListView: View {
    let interface: Interface<Action>
    let state: ViewState

    var body: some View {
        content
        // This sometimes causes an infinite loop!?
//         .animation(.default, value: state.threads)
    }

    @ViewBuilder private var content: some View {
        switch state.threads {
        case .initial, .loading:
            ProgressView()
        case .failure:
            Text("Error")
        case .loaded(let threads):
            loadedContent(threads: threads)
        }
    }

    @ViewBuilder private func loadedContent(threads: [Thread]) -> some View {
        List {
            Section {
                ForEach(threads) { thread in
                    Button {
                        interface.sendAction(.threadTapped(thread))
                    } label: {
                        HStack {
                            ThreadHeader(title: thread.title)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

extension ThreadListView {
    struct ViewState {
        var threads: LoadingState<[Thread], Error>

        static var mock: ViewState {
            .init(threads: .loaded([.mock, .random, .random, .random]))
        }
    }

    enum Action {
        case threadTapped(Thread)
    }
}

struct ThreadListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Preview(ThreadListView.init, state: .mock) { action, $state in
                switch action {
                default:
                    break
                }
            }
            .navigationTitle("Threads")
        }
        .preferredColorScheme(.dark)
    }
}
