//
//  LearnView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct LearnView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: LearnViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = State(initialValue: LearnViewModel(
            learningRepository: coordinator.learningRepository
        ))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .spacingL) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.spacingXL)
                    } else {
                        // Sport Selection
                        VStack(alignment: .leading, spacing: .spacingM) {
                            Text("Choose a Sport")
                                .font(.heading3)
                                .foregroundStyle(Color.textPrimary)

                            ForEach(viewModel.sports) { sport in
                                NavigationLink {
                                    SportModulesView(
                                        sport: sport,
                                        coordinator: coordinator
                                    )
                                } label: {
                                    SportCard(sport: sport, action: {})
                                }
                            }
                        }
                    }
                }
                .padding(.spacingM)
            }
            .navigationTitle("Learn")
            .task {
                await viewModel.loadSports()
            }
        }
    }
}

// MARK: - Sport Modules View
struct SportModulesView: View {
    let sport: Sport
    let coordinator: AppCoordinator
    @State private var modules: [Module] = []
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacingM) {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.spacingXL)
                } else {
                    ForEach(modules) { module in
                        NavigationLink {
                            ModuleLessonsView(
                                module: module,
                                sport: sport,
                                coordinator: coordinator
                            )
                        } label: {
                            ModuleCard(module: module, sport: sport)
                        }
                    }
                }
            }
            .padding(.spacingM)
        }
        .navigationTitle(sport.name)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await loadModules()
        }
    }

    private func loadModules() async {
        isLoading = true
        do {
            modules = try await coordinator.learningRepository.getModules(sportId: sport.id)
        } catch {
            print("Error loading modules: \(error)")
        }
        isLoading = false
    }
}

// MARK: - Module Card
struct ModuleCard: View {
    let module: Module
    let sport: Sport

    var body: some View {
        HStack(spacing: .spacingM) {
            VStack(alignment: .leading, spacing: .spacingS) {
                Text(module.title)
                    .font(.heading4)
                    .foregroundStyle(Color.textPrimary)

                Text(module.description)
                    .font(.bodySmall)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(2)

                HStack(spacing: .spacingM) {
                    Label("\(module.totalLessons) lessons", systemImage: "book.fill")
                    Label("\(module.estimatedMinutes) min", systemImage: "clock.fill")
                }
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            if module.isLocked {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color.textTertiary)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.spacingM)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
        .opacity(module.isLocked ? 0.6 : 1.0)
    }
}

#Preview("Learn View") {
    LearnView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository()
    ))
}
