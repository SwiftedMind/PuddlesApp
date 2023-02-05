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

struct ThreadEditNavigator: StackNavigator {

    @State private var path: [Destination] = []
    var navigationPath: Binding<[Destination]> { $path }

    @State private var thread: Thread
    let finishHandler: (_ thread: Thread?) -> Void

    init(
        thread: Thread,
        onFinish finishHandler: @escaping (_ thread: Thread?) -> Void
    ) {
        self._thread = .init(initialValue: thread)
        self.finishHandler = finishHandler
    }

    var root: some View {
        ThreadEdit(
            interface: .actionHandler(handleAction),
            thread: $thread
        )
    }

    func destination(for path: Destination) -> some View {
        Text("")
    }

    func applyStateConfiguration(_ configuration: StateConfiguration) {

    }

    func handleDeepLink(_ deepLink: URL) -> StateConfiguration? {
        nil
    }

    // MARK: - Action Handlers

    @Sendable
    private func handleAction(_ action: ThreadEdit.Action) {
        switch action {
        case .didCancel:
            finishHandler(nil)
        case .didSave:
            finishHandler(thread)
        }
    }
}

extension ThreadEditNavigator {

    enum StateConfiguration {
        case reset
    }

    enum Destination: Hashable {
        case reset
    }
}
