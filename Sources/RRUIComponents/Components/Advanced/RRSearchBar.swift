// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation

// MARK: - Search Bar

public struct RRSearchBar: View {
    @Binding private var text: String
    private let placeholder: String
    private let onSearch: (String) -> Void
    private let onCancel: () -> Void
    private let suggestions: [Suggestion]
    private let onSuggestionTap: (Suggestion) -> Void
    
    @State private var isSearching = false
    @State private var showSuggestions = false
    
    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        suggestions: [Suggestion] = [],
        onSearch: @escaping (String) -> Void = { _ in },
        onCancel: @escaping () -> Void = {},
        onSuggestionTap: @escaping (Suggestion) -> Void = { _ in }
    ) {
        self._text = text
        self.placeholder = placeholder
        self.suggestions = suggestions
        self.onSearch = onSearch
        self.onCancel = onCancel
        self.onSuggestionTap = onSuggestionTap
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            onSearch(text)
                        }
                    
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(RRSpacing.sm)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                if isSearching {
                    Button("Cancel", action: {
                        withAnimation {
                            isSearching = false
                            text = ""
                            showSuggestions = false
                        }
                        onCancel()
                    })
                    .foregroundColor(.blue)
                }
            }
            
            if showSuggestions && !suggestions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(suggestions, id: \.id) { suggestion in
                        SuggestionRow(suggestion: suggestion) {
                            onSuggestionTap(suggestion)
                            showSuggestions = false
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.top, RRSpacing.xs)
            }
        }
        .onChange(of: text) { newValue in
            showSuggestions = !newValue.isEmpty && !suggestions.isEmpty
        }
        .onTapGesture {
            withAnimation {
                isSearching = true
            }
        }
    }
}

// MARK: - Suggestion

public struct Suggestion {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let icon: String?
    
    public init(title: String, subtitle: String? = nil, icon: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}

// MARK: - Suggestion Row

private struct SuggestionRow: View {
    let suggestion: Suggestion
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: RRSpacing.sm) {
                if let icon = suggestion.icon {
                    Image(systemName: icon)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(suggestion.title)
                        .foregroundColor(.primary)
                        .font(.body)
                    
                    if let subtitle = suggestion.subtitle {
                        Text(subtitle)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                
                Spacer()
            }
            .padding(RRSpacing.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#if DEBUG
struct RRSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Search Bar")
                .font(.headline)
            
            RRSearchBar(
                text: .constant(""),
                placeholder: "Search for something...",
                suggestions: [
                    Suggestion(title: "First Result", subtitle: "This is a subtitle", icon: "magnifyingglass"),
                    Suggestion(title: "Second Result", subtitle: "Another subtitle", icon: "star"),
                    Suggestion(title: "Third Result", subtitle: "Yet another subtitle", icon: "heart")
                ],
                onSearch: { query in
                    print("Searching for: \(query)")
                },
                onSuggestionTap: { suggestion in
                    print("Tapped suggestion: \(suggestion.title)")
                }
            )
        }
        .padding()
    }
}
#endif
