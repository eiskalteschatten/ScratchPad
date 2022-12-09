//
//  RichTextEditor.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct RichTextEditor: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    var textView = NSTextView()
    
    @Binding var text: NSAttributedString
    
    func makeNSView(context: Context) -> NSTextView {
        textView.delegate = context.coordinator
        textView.isRichText = true
        textView.allowsUndo = true
        textView.allowsImageEditing = true
        textView.allowsDocumentBackgroundColorChange = true
        textView.allowsCharacterPickerTouchBarItem = true

        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(text)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextEditor
        var affectedCharRange: NSRange?
        
        init(_ parent: RichTextEditor) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.text = textView.attributedString()
        }
        
        func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
            return true
        }
    }
}

