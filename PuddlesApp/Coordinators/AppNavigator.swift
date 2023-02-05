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

struct AppNavigator: StackNavigator {

    @QueryableItem<Thread, Thread> private var threadCreation
    @State private var path: [Destination] = []
    var navigationPath: Binding<[Destination]> { $path }

    var root: some View {
        Dashboard(interface: .actionHandler(handleDashboardAction))
            .queryableSheet(controlledBy: threadCreation) { thread, query in
                threadEditNavigator(thread: thread, query: query)
            }
    }

    @ViewBuilder private func threadEditNavigator(thread: Thread, query: QueryResolver<Thread>) -> some View {
        ThreadEditNavigator(
            thread: thread 
        ) { createdThread in
            query.answer(withOptional: createdThread)
        }
    }


    func destination(for path: Destination) -> some View {
        switch path {
        case .threadList(let threads):
            ThreadList(
                interface: .actionHandler(handleThreadListAction),
                threads: .loaded(threads)
            )
        case .threadRecommendations:
            ThreadList(
                interface: .actionHandler(handleThreadListAction),
                threads: .loaded([.mock] + .repeating(.random, count: 5))
            )
        case .threadDetail(let thread):
            ThreadDetail(
                interface: .actionHandler { handleThreadDetailAction($0, thread: thread) },
                thread: .loaded(thread)
            )
        }
    }

    func applyStateConfiguration(_ configuration: StateConfiguration) {
        switch configuration {
        case .reset:
            path.removeAll()
        case .threadList(let threads):
            path = [.threadList(threads)]
        case .threadDetail(let thread):
            path = [.threadDetail(thread)]
        case .showThreadRecommendations:
            path = [.threadRecommendations]
        case .createThread(let draft):
            path.removeAll()
            queryThreadCreation(draft: draft)
        }
    }

    func handleDeepLink(_ deepLink: URL) -> StateConfiguration? {
        if deepLink.absoluteString.contains("createThread") {
            return .createThread(draftThread: .mock)
        }

        if deepLink.absoluteString.contains("mockThread") {
            return .threadDetail(.mock)
        }

        if deepLink.absoluteString.contains("showRecommendations") {
            return .showThreadRecommendations
        }

        return nil
    }

    // MARK: - Thread Creation

    private func queryThreadCreation(draft: Thread?) {
        Task {
            do {
                let thread = try await threadCreation.query(providing: draft ?? .mock)
                print(thread)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Action Handlers

    @Sendable
    private func handleDashboardAction(_ action: Dashboard.Action) {
        switch action {
        case .showRecommendationsTapped:
            path = [.threadRecommendations]
        }
    }

    @Sendable
    private func handleThreadListAction(_ action: ThreadList.Action) {
        switch action {
        case .threadTapped(let thread):
            path.append(.threadDetail(thread))
        }
    }

    @Sendable
    private func handleThreadDetailAction(_ action: ThreadDetail.Action, thread: Thread) {
        switch action {
        case .addRemarkTapped:
            print("remark: \(thread.title)")
        case .addCommentTapped :
            print("comment: \(thread.title)")
        }
    }
}

extension AppNavigator {

    enum StateConfiguration {
        case reset
        case threadList([Thread])
        case threadDetail(Thread)
        case showThreadRecommendations
        case createThread(draftThread: Thread = .draft)
    }

    enum Destination: Hashable {
        case threadRecommendations
        case threadList([Thread])
        case threadDetail(Thread)
    }
}
