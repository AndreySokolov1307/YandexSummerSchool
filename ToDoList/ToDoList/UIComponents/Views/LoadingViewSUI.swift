import SwiftUI

private let progressViewScaleEffect: CGFloat = 2

struct LoadingViewSUI: View {
    var body: some View {
        ZStack {
            Theme.Back.backPrimary.color
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(progressViewScaleEffect)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingViewSUI()
    }
}
