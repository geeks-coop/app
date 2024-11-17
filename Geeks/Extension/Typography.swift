import SwiftUI

struct TypographyModifier: ViewModifier {
   let size: CGFloat
   let weight: Font.Weight
   let lineHeight: CGFloat
   let color: Color
   
   init(size: CGFloat, weight: Font.Weight = .regular, lineHeight: CGFloat? = nil, color: Color = .primary) {
       self.size = size
       self.weight = weight
       // lineHeight가 nil이면 size의 1.5배를 기본값으로 사용
       self.lineHeight = lineHeight ?? (size * 1.5)
       self.color = color
   }
   
   func body(content: Content) -> some View {
       content
           .font(.system(size: size, weight: weight))
           .foregroundColor(color)
           .lineSpacing((lineHeight - size) / 2)
           .padding(.vertical, (lineHeight - size) / 4)
           .kerning(size * -0.04) // 기존 letterSpacing 비율 유지
           .fixedSize(horizontal: false, vertical: true)
   }
}

extension View {
   func typography(
       size: CGFloat,
       weight: Font.Weight = .medium,
       lineHeight: CGFloat? = nil,
       color: Color = .primary
   ) -> some View {
       self.modifier(TypographyModifier(
           size: size,
           weight: weight,
           lineHeight: lineHeight,
           color: color
       ))
   }
}
