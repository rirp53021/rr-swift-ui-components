import SwiftUI
import Foundation

// MARK: - Tag Input Component

/// A tag input component similar to iOS Mail app chips for managing tags
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRTagInput: View {
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
                        .font(style.inputFont)
                        .foregroundColor(style.inputTextColor)
                        .padding(.horizontal, style.inputHorizontalPadding)
                        .padding(.vertical, style.inputVerticalPadding)
                        .background(style.inputBackgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: style.inputCornerRadius)
                                .stroke(style.inputBorderColor, lineWidth: 1)
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
            .background(style.containerBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: style.containerCornerRadius)
                    .stroke(style.containerBorderColor, lineWidth: 1)
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
                Text("\(tags.count)/\(maxTags) tags")
                    .font(.caption)
                    .foregroundColor(.secondary)
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
    let text: String
    let style: TagStyle
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(style.font)
                .foregroundColor(style.textColor)
                .lineLimit(1)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(style.removeIconColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, style.horizontalPadding)
        .padding(.vertical, style.verticalPadding)
        .background(style.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(style.borderColor, lineWidth: style.borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
    }
}

// MARK: - Tag Input Style

public struct TagInputStyle {
    public let containerBackgroundColor: Color
    public let containerBorderColor: Color
    public let containerCornerRadius: CGFloat
    public let containerHorizontalPadding: CGFloat
    public let containerVerticalPadding: CGFloat
    public let inputBackgroundColor: Color
    public let inputBorderColor: Color
    public let inputTextColor: Color
    public let inputFont: Font
    public let inputCornerRadius: CGFloat
    public let inputHorizontalPadding: CGFloat
    public let inputVerticalPadding: CGFloat
    public let tagStyle: TagStyle
    
    public static let `default` = TagInputStyle(
        containerBackgroundColor: Color(.systemBackground),
        containerBorderColor: Color(.systemGray4),
        containerCornerRadius: 8,
        containerHorizontalPadding: 12,
        containerVerticalPadding: 12,
        inputBackgroundColor: Color.clear,
        inputBorderColor: Color.clear,
        inputTextColor: .primary,
        inputFont: .body,
        inputCornerRadius: 4,
        inputHorizontalPadding: 8,
        inputVerticalPadding: 8,
        tagStyle: .default
    )
    
    public static let filled = TagInputStyle(
        containerBackgroundColor: Color(.systemGray6),
        containerBorderColor: Color(.systemGray4),
        containerCornerRadius: 8,
        containerHorizontalPadding: 12,
        containerVerticalPadding: 12,
        inputBackgroundColor: Color(.systemBackground),
        inputBorderColor: Color(.systemGray3),
        inputTextColor: .primary,
        inputFont: .body,
        inputCornerRadius: 4,
        inputHorizontalPadding: 8,
        inputVerticalPadding: 8,
        tagStyle: .filled
    )
    
    public static let outlined = TagInputStyle(
        containerBackgroundColor: Color.clear,
        containerBorderColor: Color(.systemGray4),
        containerCornerRadius: 8,
        containerHorizontalPadding: 12,
        containerVerticalPadding: 12,
        inputBackgroundColor: Color.clear,
        inputBorderColor: Color(.systemGray3),
        inputTextColor: .primary,
        inputFont: .body,
        inputCornerRadius: 4,
        inputHorizontalPadding: 8,
        inputVerticalPadding: 8,
        tagStyle: .outlined
    )
}

// MARK: - Tag Style

public struct TagStyle {
    public let backgroundColor: Color
    public let textColor: Color
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let font: Font
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let cornerRadius: CGFloat
    public let removeIconColor: Color
    
    public static let `default` = TagStyle(
        backgroundColor: Color(.systemBlue).opacity(0.1),
        textColor: .blue,
        borderColor: Color(.systemBlue).opacity(0.3),
        borderWidth: 1,
        font: .caption,
        horizontalPadding: 8,
        verticalPadding: 4,
        cornerRadius: 12,
        removeIconColor: .blue
    )
    
    public static let filled = TagStyle(
        backgroundColor: Color(.systemBlue),
        textColor: .white,
        borderColor: Color.clear,
        borderWidth: 0,
        font: .caption,
        horizontalPadding: 8,
        verticalPadding: 4,
        cornerRadius: 12,
        removeIconColor: .white
    )
    
    public static let outlined = TagStyle(
        backgroundColor: Color.clear,
        textColor: .blue,
        borderColor: Color(.systemBlue),
        borderWidth: 1,
        font: .caption,
        horizontalPadding: 8,
        verticalPadding: 4,
        cornerRadius: 12,
        removeIconColor: .blue
    )
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRTagInput_Previews: PreviewProvider {
    @State static var tags = ["Swift", "iOS", "SwiftUI"]
    @State static var emptyTags: [String] = []
    
    static var previews: some View {
        VStack(spacing: 20) {
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
        .padding()
        .previewDisplayName("RRTagInput")
    }
}
