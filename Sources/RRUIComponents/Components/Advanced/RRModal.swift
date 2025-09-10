// Copyright (c) 2024 Ronald Ruiz
// Licensed under the MIT License

import SwiftUI
import Foundation
import Combine

// MARK: - Modal Presentation Style

public enum PresentationStyle: Equatable {
    case sheet
    case fullScreenCover
    case popover
    case bottomSheet
    
    public static func == (lhs: PresentationStyle, rhs: PresentationStyle) -> Bool {
        switch (lhs, rhs) {
        case (.sheet, .sheet), (.fullScreenCover, .fullScreenCover), (.popover, .popover), (.bottomSheet, .bottomSheet):
            return true
        default:
            return false
        }
    }
}

// MARK: - RRModal

public struct RRModal<Content: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let isPresented: Binding<Bool>
    private let style: PresentationStyle
    private let onDismiss: (() -> Void)?
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
    public init(
        _ style: PresentationStyle = .sheet,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    public var body: some View {
        if isPresented.wrappedValue {
            ZStack {
                // Background overlay
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
                
                // Modal content
                modalContent
            }
            .transition(.opacity)
            .animation(DesignTokens.Animation.spring, value: isPresented.wrappedValue)
        }
    }
    
    @ViewBuilder
    private var modalContent: some View {
        switch style {
        case .sheet:
            sheetContent
        case .fullScreenCover:
            fullScreenContent
        case .popover:
            popoverContent
        case .bottomSheet:
            bottomSheetContent
        }
    }
    
    private var sheetContent: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                content
            }
            .background(theme.colors.surface)
            .cornerRadius(DesignTokens.BorderRadius.lg)
            .shadow(color: theme.colors.surface.opacity(0.3), radius: 10, x: 0, y: -5)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var fullScreenContent: some View {
        VStack(spacing: 0) {
            content
        }
        .background(theme.colors.surface)
        .ignoresSafeArea()
    }
    
    private var popoverContent: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                content
            }
            .background(theme.colors.surface)
            .cornerRadius(DesignTokens.BorderRadius.lg)
            .shadow(color: theme.colors.surface.opacity(0.3), radius: 10, x: 0, y: -5)
            .frame(maxWidth: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var bottomSheetContent: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                // Handle for bottom sheet
                RoundedRectangle(cornerRadius: DesignTokens.BorderRadius.xs)
                    .fill(theme.colors.outlineVariant)
                    .frame(width: 40, height: 4)
                    .padding(.top, DesignTokens.Spacing.sm)
                
                content
            }
            .background(theme.colors.surface)
            .cornerRadius(DesignTokens.BorderRadius.lg)
            .shadow(color: theme.colors.surface.opacity(0.3), radius: 10, x: 0, y: -5)
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = max(0, value.translation.height)
                    }
                    .onEnded { value in
                        isDragging = false
                        if value.translation.height > 100 {
                            dismiss()
                        } else {
                            withAnimation(DesignTokens.Animation.spring) {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func dismiss() {
        withAnimation(DesignTokens.Animation.spring) {
            isPresented.wrappedValue = false
        }
        onDismiss?()
    }
}

// MARK: - Modal Manager

public class RRModalManager: ObservableObject {
    public static let shared = RRModalManager()
    
    @Published public var isPresented = false
    @Published public var currentModal: AnyView?
    
    private init() {}
    
    public func show<Content: View>(
        _ style: PresentationStyle = .sheet,
        @ViewBuilder content: @escaping () -> Content
    ) {
        currentModal = AnyView(
            RRModal(style, isPresented: .constant(true)) {
                content()
            }
        )
        isPresented = true
    }
    
    public func dismiss() {
        isPresented = false
    }
}

// MARK: - Preview

#if DEBUG
struct RRModal_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var showSheet = false
        @State private var showBottomSheet = false
        @State private var showFullScreen = false
        @State private var showPopover = false
        @State private var showCustomModal = false
        
        var body: some View {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    RRLabel.title("Modal Examples")
                    
                    VStack(spacing: DesignTokens.Spacing.md) {
                        RRButton(
                            "Show Sheet Modal",
                            style: .primary,
                            action: { 
                                print("Sheet button tapped")
                                showSheet = true 
                            }
                        )
                        
                        RRButton(
                            "Show Bottom Sheet",
                            style: .primary,
                            action: {
                                print("Bottom sheet button tapped")
                                showBottomSheet = true 
                            }
                        )
                        
                        RRButton(
                            "Show Full Screen",
                            style: .primary,
                            action: {
                                print("Full screen button tapped")
                                showFullScreen = true 
                            }
                        )
                        
                        RRButton(
                            "Show Popover",
                            style: .primary,
                            action: {
                                print("Popover button tapped")
                                showPopover = true 
                            }
                        )
                        
                        RRButton(
                            "Show Custom Modal",
                            style: .primary,
                            action: { 
                                print("Custom modal button tapped")
                                showCustomModal = true 
                            }
                        )
                    }
                }
                .padding(DesignTokens.Spacing.md)
            }
            .sheet(isPresented: $showSheet) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel.title("Sheet Modal")
                    RRLabel.body("This is a native sheet modal presentation.")
                    RRLabel.caption("Tap outside or use the close button to dismiss.")
                    
                    RRButton(
                        "Close",
                        style: .primary,
                        action: { 
                            print("Closing sheet")
                            showSheet = false 
                        }
                    )
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .overlay(
                Group {
                    if showFullScreen {
                        RRModal(.fullScreenCover, isPresented: $showFullScreen) {
                            VStack(spacing: DesignTokens.Spacing.md) {
                                RRLabel.title("Full Screen Modal")
                                RRLabel.body("This is a full screen cover presentation.")
                                RRLabel.caption("Tap outside or use the close button to dismiss.")
                                
                                RRButton(
                                    "Close",
                                    style: .primary,
                                    action: { 
                                        print("Closing full screen")
                                        showFullScreen = false 
                                    }
                                )
                            }
                            .padding(DesignTokens.Spacing.lg)
                        }
                    }
                    
                    if showBottomSheet {
                        RRModal(.bottomSheet, isPresented: $showBottomSheet) {
                            VStack(spacing: DesignTokens.Spacing.md) {
                                RRLabel.title("Bottom Sheet")
                                RRLabel.body("This is a custom bottom sheet modal.")
                                RRLabel.caption("Drag down or tap outside to dismiss.")
                                
                                RRButton(
                                    "Close",
                                    style: .primary,
                                    action: { 
                                        print("Closing bottom sheet")
                                        showBottomSheet = false 
                                    }
                                )
                            }
                            .padding(DesignTokens.Spacing.lg)
                        }
                    }
                    
                    if showPopover {
                        RRModal(.popover, isPresented: $showPopover) {
                            VStack(spacing: DesignTokens.Spacing.md) {
                                RRLabel.title("Popover Modal")
                                RRLabel.body("This is a popover-style modal.")
                                RRLabel.caption("Tap outside to dismiss.")
                                
                                RRButton(
                                    "Close",
                                    style: .primary,
                                    action: { 
                                        print("Closing popover")
                                        showPopover = false 
                                    }
                                )
                            }
                            .padding(DesignTokens.Spacing.lg)
                        }
                    }
                    
                    if showCustomModal {
                        RRModal(.sheet, isPresented: $showCustomModal) {
                            VStack(spacing: DesignTokens.Spacing.md) {
                                RRLabel.title("Custom Sheet Modal")
                                RRLabel.body("This is a custom sheet modal using RRModal.")
                                RRLabel.caption("Tap outside or use the close button to dismiss.")
                                
                                RRButton(
                                    "Close",
                                    style: .primary,
                                    action: { 
                                        print("Closing custom modal")
                                        showCustomModal = false 
                                    }
                                )
                            }
                            .padding(DesignTokens.Spacing.lg)
                        }
                    }
                }
            )
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
            .previewDisplayName("RRModal")
    }
}
#endif

