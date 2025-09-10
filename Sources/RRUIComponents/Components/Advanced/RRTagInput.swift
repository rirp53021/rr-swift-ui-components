import SwiftUI
import Foundation

// MARK: - Tag Input Component

/// A tag input component similar to iOS Mail app chips for managing tags
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRTagInput: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @Binding private var tags: [String]
    @State private var inputText = ""
    @State private var isEditing = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let placeholder: String
    private let style: TagInputStyle
    private let maxTags: Int?
    private let allowedCharacters: CharacterSet
    private let onTagAdded: ((String) -> Void)?
    private let onTagRemoved: ((String) -> Void)?
    
    public init(
        tags: Binding<[String]>,
        placeholder: String = "Add tags...",
        style: TagInputStyle = .default,
        maxTags: Int? = nil,
        allowedCharacters: CharacterSet = .alphanumerics.union(.whitespaces).union(.punctuationCharacters),
        onTagAdded: ((String) -> Void)? = nil,
        onTagRemoved: ((String) -> Void)? = nil
    ) {
        self._tags = tags
        self.placeholder = placeholder
        self.style = style
        self.maxTags = maxTags
        self.allowedCharacters = allowedCharacters
        self.onTagAdded = onTagAdded
        self.onTagRemoved = onTagRemoved
    }
    
    private var canAddTag: Bool {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedText.isEmpty && 
               !tags.contains(trimmedText) && 
               (maxTags == nil || tags.count < maxTags!)
    }
    
    private func addTag() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard canAddTag else { return }
        
        tags.append(trimmedText)
        onTagAdded?(trimmedText)
        inputText = ""
    }
    
    private func removeTag(_ tag: String) {
        if let index = tags.firstIndex(of: tag) {
            tags.remove(at: index)
            onTagRemoved?(tag)
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                // Tags
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 80), spacing: 8)
                ], spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        TagView(
                            text: tag,
                            style: style.tagStyle,
                            onRemove: { removeTag(tag) }
                        )
                    }
                }
                
                // Input field
                if isEditing || tags.isEmpty {
                    TextField(placeholder, text: $inputText)
                        .focused($isTextFieldFocused)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.body)
                        .foregroundColor(style.inputTextColor(theme))
                        .padding(.horizontal, style.inputHorizontalPadding)
                        .padding(.vertical, style.inputVerticalPadding)
                        .background(style.inputBackgroundColor(theme))
                        .overlay(
                            RoundedRectangle(cornerRadius: style.inputCornerRadius)
                                .stroke(style.inputBorderColor(theme), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: style.inputCornerRadius))
                        .onSubmit {
                            addTag()
                        }
                        .onChange(of: inputText) { newValue in
                            // Filter allowed characters
                            let filtered = newValue.filter { allowedCharacters.contains($0.unicodeScalars.first!) }
                            if filtered != newValue {
                                inputText = filtered
                            }
                        }
                }
            }
            .padding(.horizontal, style.containerHorizontalPadding)
            .padding(.vertical, style.containerVerticalPadding)
            .background(style.containerBackgroundColor(theme))
            .overlay(
                RoundedRectangle(cornerRadius: style.containerCornerRadius)
                    .stroke(style.containerBorderColor(theme), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: style.containerCornerRadius))
            .onTapGesture {
                if !isEditing {
                    isEditing = true
                    isTextFieldFocused = true
                }
            }
            
            // Helper text
            if let maxTags = maxTags {
                RRLabel("\(tags.count)/\(maxTags) tags", style: .caption, weight: .regular, color: .secondary)
                    .padding(.horizontal, style.containerHorizontalPadding)
            }
        }
        .onAppear {
            if tags.isEmpty {
                isEditing = true
            }
        }
    }
}

// MARK: - Tag View

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct TagView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let text: String
    let style: TagStyle
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            RRLabel(text, style: style.labelStyle, weight: .regular, customColor: style.textColor(theme))
                .lineLimit(1)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(style.removeIconColor(theme))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, style.verticalPadding)
        .background(style.backgroundColor(theme))
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(style.borderColor(theme), lineWidth: style.borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
    }
}

// MARK: - Tag Input Style

public struct TagInputStyle {
    public let containerBackgroundColor: (Theme) -> Color
    public let containerBorderColor: (Theme) -> Color
    public let containerCornerRadius: CGFloat
    public let containerHorizontalPadding: CGFloat
    public let containerVerticalPadding: CGFloat
    public let inputBackgroundColor: (Theme) -> Color
    public let inputBorderColor: (Theme) -> Color
    public let inputTextColor: (Theme) -> Color
    public let inputLabelStyle: RRLabel.Style
    public let inputCornerRadius: CGFloat
    public let inputHorizontalPadding: CGFloat
    public let inputVerticalPadding: CGFloat
    public let tagStyle: TagStyle
    
    public static let `default` = TagInputStyle(
        containerBackgroundColor: { theme in theme.colors.surface },
        containerBorderColor: { theme in theme.colors.outline },
        containerCornerRadius: DesignTokens.BorderRadius.md,
        containerHorizontalPadding: DesignTokens.Spacing.md,
        containerVerticalPadding: DesignTokens.Spacing.md,
        inputBackgroundColor: { theme in Color.clear },
        inputBorderColor: { theme in Color.clear },
        inputTextColor: { theme in theme.colors.primaryText },
        inputLabelStyle: .body,
        inputCornerRadius: DesignTokens.BorderRadius.sm,
        inputHorizontalPadding: DesignTokens.Spacing.sm,
        inputVerticalPadding: DesignTokens.Spacing.sm,
        tagStyle: .default
    )
    
    public static let filled = TagInputStyle(
        containerBackgroundColor: { theme in theme.colors.surfaceVariant },
        containerBorderColor: { theme in theme.colors.outline },
        containerCornerRadius: DesignTokens.BorderRadius.md,
        containerHorizontalPadding: DesignTokens.Spacing.md,
        containerVerticalPadding: DesignTokens.Spacing.md,
        inputBackgroundColor: { theme in theme.colors.surface },
        inputBorderColor: { theme in theme.colors.outline },
        inputTextColor: { theme in theme.colors.primaryText },
        inputLabelStyle: .body,
        inputCornerRadius: DesignTokens.BorderRadius.sm,
        inputHorizontalPadding: DesignTokens.Spacing.sm,
        inputVerticalPadding: DesignTokens.Spacing.sm,
        tagStyle: .filled
    )
    
    public static let outlined = TagInputStyle(
        containerBackgroundColor: { theme in Color.clear },
        containerBorderColor: { theme in theme.colors.outline },
        containerCornerRadius: DesignTokens.BorderRadius.md,
        containerHorizontalPadding: DesignTokens.Spacing.md,
        containerVerticalPadding: DesignTokens.Spacing.md,
        inputBackgroundColor: { theme in Color.clear },
        inputBorderColor: { theme in theme.colors.outline },
        inputTextColor: { theme in theme.colors.primaryText },
        inputLabelStyle: .body,
        inputCornerRadius: DesignTokens.BorderRadius.sm,
        inputHorizontalPadding: DesignTokens.Spacing.sm,
        inputVerticalPadding: DesignTokens.Spacing.sm,
        tagStyle: .outlined
    )
}

// MARK: - Tag Style

public struct TagStyle {
    public let backgroundColor: (Theme) -> Color
    public let textColor: (Theme) -> Color
    public let borderColor: (Theme) -> Color
    public let borderWidth: CGFloat
    public let labelStyle: RRLabel.Style
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let cornerRadius: CGFloat
    public let removeIconColor: (Theme) -> Color
    
    public static let `default` = TagStyle(
        backgroundColor: { theme in theme.colors.primary.opacity(0.1) },
        textColor: { theme in theme.colors.primary },
        borderColor: { theme in theme.colors.primary.opacity(0.3) },
        borderWidth: 1,
        labelStyle: .caption,
        horizontalPadding: DesignTokens.Spacing.sm,
        verticalPadding: DesignTokens.Spacing.xs,
        cornerRadius: DesignTokens.BorderRadius.lg,
        removeIconColor: { theme in theme.colors.primary }
    )
    
    public static let filled = TagStyle(
        backgroundColor: { theme in theme.colors.primary },
        textColor: { theme in theme.colors.onPrimary },
        borderColor: { theme in Color.clear },
        borderWidth: 0,
        labelStyle: .caption,
        horizontalPadding: DesignTokens.Spacing.sm,
        verticalPadding: DesignTokens.Spacing.xs,
        cornerRadius: DesignTokens.BorderRadius.lg,
        removeIconColor: { theme in theme.colors.onPrimary }
    )
    
    public static let outlined = TagStyle(
        backgroundColor: { theme in Color.clear },
        textColor: { theme in theme.colors.primary },
        borderColor: { theme in theme.colors.primary },
        borderWidth: 1,
        labelStyle: .caption,
        horizontalPadding: DesignTokens.Spacing.sm,
        verticalPadding: DesignTokens.Spacing.xs,
        cornerRadius: DesignTokens.BorderRadius.lg,
        removeIconColor: { theme in theme.colors.primary }
    )
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRTagInput_Previews: PreviewProvider {
    @State static var tags = ["Swift", "iOS", "SwiftUI"]
    @State static var emptyTags: [String] = []
    
    static var previews: some View {
        RRTagInputPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRTagInput Examples")
    }
}

private struct RRTagInputPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    @State private var tags = ["Swift", "iOS", "SwiftUI"]
    @State private var emptyTags: [String] = []
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            RRTagInput(
                tags: $tags,
                placeholder: "Add skills...",
                style: .default,
                maxTags: 10
            )
            
            RRTagInput(
                tags: $emptyTags,
                placeholder: "Add tags...",
                style: .filled
            )
            
            RRTagInput(
                tags: $tags,
                placeholder: "Add categories...",
                style: .outlined,
                maxTags: 5
            )
        }
        .padding(DesignTokens.Spacing.componentPadding)
    }
}
