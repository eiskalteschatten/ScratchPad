//
//  RichTextEditor.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct RichTextEditor: NSViewRepresentable {
    @EnvironmentObject var noteModel: NoteModel
    
    // Only used for debugging. See comments below
    @State private var text = NSAttributedString(string: "")
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        
        guard let textView = scrollView.documentView as? NSTextView else {
            return scrollView
        }

        textView.delegate = context.coordinator
        textView.isRichText = true
        textView.allowsUndo = true
        textView.allowsImageEditing = true
        textView.allowsDocumentBackgroundColorChange = true
        textView.allowsCharacterPickerTouchBarItem = true
        textView.isAutomaticLinkDetectionEnabled = true
        textView.displaysLinkToolTips = true
        textView.isAutomaticDataDetectionEnabled = true
        textView.isAutomaticTextReplacementEnabled = true
        textView.isAutomaticDashSubstitutionEnabled = true
        textView.isAutomaticSpellingCorrectionEnabled = true
        textView.isAutomaticQuoteSubstitutionEnabled = true
        textView.isAutomaticTextCompletionEnabled = true
        textView.isContinuousSpellCheckingEnabled = true
        textView.usesAdaptiveColorMappingForDarkAppearance = true
        textView.usesInspectorBar = true
        textView.usesRuler = true
        textView.usesFindBar = true
        textView.usesFontPanel = true
        textView.importsGraphics = true
        
        context.coordinator.textView = textView
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        context.coordinator.textView?.textStorage?.setAttributedString(noteModel.noteContents)
//        If I replace the above line with this line, formatting and images work
//        context.coordinator.textView?.textStorage?.setAttributedString(text)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextEditor
        var textView : NSTextView?
        
        init(_ parent: RichTextEditor) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let _textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.noteModel.noteContents = _textView.attributedString()
//        If I replace the above line with this line, formatting and images work
//            self.parent.text = _textView.attributedString()
        }
        
        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
            return true
        }
    }
}

