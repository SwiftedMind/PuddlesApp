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

import Puddles

struct ThreadEdit: Coordinator {

    let interface: Interface<Action>
    @Binding var thread: Thread

    var entryView: some View {
        ThreadEditView(
            interface: .actionHandler(handleViewAction),
            state: .init(
                thread: thread
            )
        )
        .navigationTitle("New Thread")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
    }

    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel", role: .cancel) {
                interface.sendAction(.didCancel)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                interface.sendAction(.didSave)
            }
            .bold()
        }
    }

    // MARK: - Action Handlers

    @Sendable
    private func handleViewAction(_ action: ThreadEditView.Action) {
        switch action {
        case .titleChanged(let newTitle):
            thread.title = newTitle
        }
    }
}

extension ThreadEdit {

    enum Action {
        case didCancel
        case didSave
    }
}
