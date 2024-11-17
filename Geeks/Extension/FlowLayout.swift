//
//  FlowLayout.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/12/24.
//
import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let positions = layout(sizes: sizes, proposal: proposal).positions
        
        for (index, subview) in subviews.enumerated() {
            subview.place(at: positions[index].applying(.init(translationX: bounds.minX, y: bounds.minY)), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], proposal: ProposedViewSize) -> (positions: [CGPoint], size: CGSize) {
        let width = proposal.width ?? 0
        var current = CGPoint.zero
        var maxY: CGFloat = 0
        
        var positions: [CGPoint] = []
        
        for size in sizes {
            if current.x + size.width > width, current.x > 0 {
                current.x = 0
                current.y = maxY + spacing
            }
            
            positions.append(current)
            current.x += size.width + spacing
            maxY = max(maxY, current.y + size.height)
        }
        
        return (positions, CGSize(width: width, height: maxY))
    }
}
