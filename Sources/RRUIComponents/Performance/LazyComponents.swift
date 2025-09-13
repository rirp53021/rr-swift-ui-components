// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Lazy Components

/// Lazy loading wrapper for expensive components
public struct LazyComponent<Content: View>: View {
    private let content: () -> Content
    @State private var isLoaded = false
    @State private var loadingTask: Task<Void, Never>?
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Group {
            if isLoaded {
                content()
            } else {
                LazyLoadingPlaceholder()
                    .onAppear {
                        loadContent()
                    }
            }
        }
    }
    
    private func loadContent() {
        loadingTask?.cancel()
        loadingTask = Task {
            // Simulate loading delay for expensive operations
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            
            if !Task.isCancelled {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isLoaded = true
                    }
                }
            }
        }
    }
}

/// Lazy loading placeholder with loading indicator
private struct LazyLoadingPlaceholder: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        VStack(spacing: 8) {
            RRLoadingIndicator(style: .spinner, size: 16)
            
            RRLabel("Loading...", style: .caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.surface)
    }
}

// MARK: - Lazy List Components

/// Lazy loading list for large datasets
public struct LazyList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let content: (Data.Element) -> Content
    private let batchSize: Int
    private let threshold: Int
    
    @State private var visibleItems: [Data.Element] = []
    @State private var isLoading = false
    
    public init(
        data: Data,
        batchSize: Int = 20,
        threshold: Int = 5,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.batchSize = batchSize
        self.threshold = threshold
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(visibleItems.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .onAppear {
                            loadMoreIfNeeded(at: index)
                        }
                }
                
                if isLoading {
                    LazyLoadingPlaceholder()
                        .frame(height: 50)
                }
            }
        }
        .onAppear {
            loadInitialItems()
        }
    }
    
    private func loadInitialItems() {
        let initialCount = min(batchSize, data.count)
        visibleItems = Array(data.prefix(initialCount))
    }
    
    private func loadMoreIfNeeded(at index: Int) {
        guard !isLoading,
              index >= visibleItems.count - threshold,
              visibleItems.count < data.count else { return }
        
        isLoading = true
        
        DelayedExecution.after(0.1) {
            let startIndex = visibleItems.count
            let endIndex = min(startIndex + batchSize, data.count)
            let newItems = Array(data.dropFirst(startIndex).prefix(endIndex - startIndex))
            
            visibleItems.append(contentsOf: newItems)
            isLoading = false
        }
    }
}

// MARK: - Lazy Grid Components

/// Lazy loading grid for large datasets
public struct LazyGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let columns: [GridItem]
    private let content: (Data.Element) -> Content
    private let batchSize: Int
    private let threshold: Int
    
    @State private var visibleItems: [Data.Element] = []
    @State private var isLoading = false
    
    public init(
        data: Data,
        columns: [GridItem],
        batchSize: Int = 20,
        threshold: Int = 5,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.content = content
        self.batchSize = batchSize
        self.threshold = threshold
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(visibleItems.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .onAppear {
                            loadMoreIfNeeded(at: index)
                        }
                }
                
                if isLoading {
                    LazyLoadingPlaceholder()
                        .frame(height: 100)
                }
            }
            .padding()
        }
        .onAppear {
            loadInitialItems()
        }
    }
    
    private func loadInitialItems() {
        let initialCount = min(batchSize, data.count)
        visibleItems = Array(data.prefix(initialCount))
    }
    
    private func loadMoreIfNeeded(at index: Int) {
        guard !isLoading,
              index >= visibleItems.count - threshold,
              visibleItems.count < data.count else { return }
        
        isLoading = true
        
        DelayedExecution.after(0.1) {
            let startIndex = visibleItems.count
            let endIndex = min(startIndex + batchSize, data.count)
            let newItems = Array(data.dropFirst(startIndex).prefix(endIndex - startIndex))
            
            visibleItems.append(contentsOf: newItems)
            isLoading = false
        }
    }
}

// MARK: - Lazy Image Components

/// Lazy loading image component
public struct LazyImage: View {
    private let url: URL?
    private let placeholder: Image?
    private let errorImage: Image?
    private let contentMode: ContentMode
    
    @State private var isLoading = true
    @State private var hasError = false
    @State private var loadedImage: Image?
    
    public init(
        url: URL?,
        placeholder: Image? = nil,
        errorImage: Image? = nil,
        contentMode: ContentMode = .fit
    ) {
        self.url = url
        self.placeholder = placeholder
        self.errorImage = errorImage
        self.contentMode = contentMode
    }
    
    public var body: some View {
        Group {
            if let loadedImage = loadedImage {
                loadedImage
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if hasError {
                if let errorImage = errorImage {
                    errorImage
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                }
            } else {
                if let placeholder = placeholder {
                    placeholder
                } else {
                    LazyLoadingPlaceholder()
                }
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = url else {
            hasError = true
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                await MainActor.run {
                    #if canImport(UIKit)
                    if let uiImage = UIImage(data: data) {
                        loadedImage = Image(uiImage: uiImage)
                    } else {
                        hasError = true
                    }
                    #else
                    hasError = true
                    #endif
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    hasError = true
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Lazy Tab View

/// Lazy loading tab view that only loads visible tabs
public struct LazyTabView<Content: View>: View {
    private let content: () -> Content
    @State private var isLoaded = false
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Group {
            if isLoaded {
                content()
            } else {
                LazyLoadingPlaceholder()
                    .onAppear {
                        DelayedExecution.after(0.1) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isLoaded = true
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Lazy Modal

/// Lazy loading modal that only loads content when presented
public struct LazyModal<Content: View>: View {
    @Binding private var isPresented: Bool
    private let content: () -> Content
    @State private var isContentLoaded = false
    
    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.content = content
    }
    
    public var body: some View {
        EmptyView()
            .sheet(isPresented: $isPresented) {
                Group {
                    if isContentLoaded {
                        content()
                    } else {
                        LazyLoadingPlaceholder()
                            .onAppear {
                                DelayedExecution.after(0.1) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isContentLoaded = true
                                    }
                                }
                            }
                    }
                }
                .onDisappear {
                    isContentLoaded = false
                }
            }
    }
}

// MARK: - Lazy Carousel

/// Lazy loading carousel that only loads visible items
public struct LazyCarousel<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let content: (Data.Element) -> Content
    private let visibleRange: Int
    
    @State private var currentIndex: Int = 0
    @State private var loadedItems: [Data.Element] = []
    
    public init(
        data: Data,
        visibleRange: Int = 3,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.visibleRange = visibleRange
    }
    
    public var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(loadedItems.enumerated()), id: \.element.id) { index, item in
                content(item)
                    .tag(index)
                    .onAppear {
                        loadNearbyItems(for: index)
                    }
            }
        }
        #if os(iOS) || os(tvOS) || os(watchOS)
        .tabViewStyle(PageTabViewStyle())
        #endif
        .onAppear {
            loadInitialItems()
        }
    }
    
    private func loadInitialItems() {
        let startIndex = max(0, currentIndex - visibleRange)
        let endIndex = min(data.count, currentIndex + visibleRange + 1)
        loadedItems = Array(data.dropFirst(startIndex).prefix(endIndex - startIndex))
    }
    
    private func loadNearbyItems(for index: Int) {
        let startIndex = max(0, index - visibleRange)
        let endIndex = min(data.count, index + visibleRange + 1)
        let newItems = Array(data.dropFirst(startIndex).prefix(endIndex - startIndex))
        
        if !newItems.elementsEqual(loadedItems, by: { $0.id == $1.id }) {
            loadedItems = newItems
        }
    }
}

// MARK: - View Extensions

