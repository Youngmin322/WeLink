//
//  SearchView.swift
//  WeLink
//
//  Created by weonyee on 8/6/25.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("이름 또는 태그 검색", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // 검색 결과 리스트 등 추가 가능
                Spacer()
            }
            .navigationTitle("검색")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
        }
    }
}
