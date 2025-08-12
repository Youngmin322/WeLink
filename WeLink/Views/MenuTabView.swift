import SwiftUI
import SwiftData

// MARK: - MemoStore (ObservableObject로 상태 관리)
class MemoStore: ObservableObject {
    @Published var memos: [Date: [(text: String, writer: String)]] = [:]
}

// MARK: - CustomCalendarView
struct CustomCalendarView: View {
    @Binding var selectedDate: Date?
    var cards: [CardModel]
    var memoDates: Set<Date>
    
    @State private var currentMonth: Date = Date()
    
    private var days: [Date] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        
        let startDate = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: startDate) - 1
        
        var days: [Date] = []
        for _ in 0..<firstWeekday {
            days.append(Date.distantPast)
        }
        
        var day = startDate
        while day < monthInterval.end {
            days.append(day)
            day = calendar.date(byAdding: .day, value: 1, to: day)!
        }
        
        return days
    }
    
    var body: some View {
        VStack {
            // 월 이동 헤더
            HStack {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthTitle)
                    .font(.headline)
                
                Spacer()
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .foregroundColor(Color("MainColor"))
            
            // 요일 헤더
            let weekdays = Calendar.current.shortWeekdaySymbols
            HStack(spacing: 4) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 10))
                        .frame(width: 40)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 4)
            
            // 날짜 그리드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, date in
                    if date == Date.distantPast {
                        Color.clear.frame(height: 40)
                    } else {
                        DayCell(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date.distantPast),
                            isToday: Calendar.current.isDate(date, inSameDayAs: Date()),
                            hasBirthday: hasBirthday(on: date),
                            hasMemo: memoDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: currentMonth)
    }
    
    private func changeMonth(_ value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func hasBirthday(on date: Date) -> Bool {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return cards.contains {
            guard let bd = $0.birthDateAsDate else { return false }
            return calendar.component(.month, from: bd) == month &&
                   calendar.component(.day, from: bd) == day
        }
    }
}

// MARK: - DayCell
struct DayCell: View {
    var date: Date
    var isSelected: Bool
    var isToday: Bool
    var hasBirthday: Bool
    var hasMemo: Bool
    
    @State private var animateScale: Bool = false
    
    var body: some View {
        ZStack {
            if hasMemo {
                Circle()
                    .fill(Color("MainColor").opacity(0.2))
                    .frame(width: 42, height: 42)
            }
            
            if isSelected {
                Circle()
                    .stroke(Color("MainColor"), lineWidth: 2)
                    .frame(width: 42, height: 42)
                    .scaleEffect(animateScale ? 1.1 : 1.0)
                    .onAppear {
                        animateScale = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            animateScale = false
                        }
                    }
            }
            
            VStack(spacing: 0) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .foregroundColor(hasBirthday ? Color("MainColor") : .white)
                    .fontWeight(isToday ? .bold : .regular)
                    .frame(height: 20)
                
                if isToday {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 5, height: 5)
                        .padding(.top, 4)
                } else {
                    Spacer().frame(height: 9)
                }
            }
            .frame(height: 42)
        }
        .frame(height: 42)
    }
}

// MARK: - MemoSheetView
struct MemoSheetView: View {
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date
    @Binding var memoText: String
    @Binding var selectedWriter: String
    
    let writers = ["Karina", "Ning ning", "Winter", "Giselle"]
    
    @State private var month: Int = Calendar.current.component(.month, from: Date())
    @State private var day: Int = Calendar.current.component(.day, from: Date())
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.top, 12)
            
            Text("메모 작성")
                .font(.headline)
                .foregroundColor(Color("MainColor"))
                .padding(.bottom, 4)
            
            HStack(spacing: 50) {
                VStack {
                    Text("월")
                        .foregroundColor(.secondary)
                    Picker("월", selection: $month) {
                        ForEach(1...12, id: \.self) { m in
                            Text("\(m)월").tag(m)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80, height: 120)
                }
                
                VStack {
                    Text("일")
                        .foregroundColor(.secondary)
                    Picker("일", selection: $day) {
                        ForEach(1...31, id: \.self) { d in
                            Text("\(d)일").tag(d)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80, height: 120)
                }
            }
            .onAppear {
                let comps = Calendar.current.dateComponents([.month, .day], from: selectedDate)
                month = comps.month ?? month
                day = comps.day ?? day
            }
            .onChange(of: month) { _ in updateSelectedDate() }
            .onChange(of: day) { _ in updateSelectedDate() }
            
            VStack(alignment: .leading) {
                Text("작성자")
                    .foregroundColor(.secondary)
                Picker("작성자", selection: $selectedWriter) {
                    ForEach(writers, id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(Color("MainColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            TextEditor(text: $memoText)
                .frame(height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("MainColor"), lineWidth: 1)
                )
            
            Button {
                isPresented = false
            } label: {
                Text("저장")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("MainColor"))
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .cornerRadius(20)
        .preferredColorScheme(.dark)
        .presentationDetents([.fraction(0.7)])
    }
    
    private func updateSelectedDate() {
        var comps = Calendar.current.dateComponents([.year], from: selectedDate)
        comps.month = month
        comps.day = day
        if let newDate = Calendar.current.date(from: comps) {
            selectedDate = newDate
        }
    }
}

// MARK: - MenuTabView
struct MenuTabView: View {
    @State private var selectedDate: Date? = Date()  // 여기 기본값으로 오늘 날짜 지정
    @State private var memoText: String = ""
    @State private var isMemoSheetPresented: Bool = false
    @State private var selectedWriter: String = "Karina"
    
    @Query private var cards: [CardModel]
    @StateObject private var memoStore = MemoStore()

    var memoDates: Set<Date> {
        Set(memoStore.memos.keys)
    }
    
    var birthdayCardsForSelectedDate: [CardModel] {
        guard let selectedDate = selectedDate else { return [] }
        let selMonth = Calendar.current.component(.month, from: selectedDate)
        let selDay = Calendar.current.component(.day, from: selectedDate)
        
        return cards.filter {
            guard let bd = $0.birthDateAsDate else { return false }
            let bMonth = Calendar.current.component(.month, from: bd)
            let bDay = Calendar.current.component(.day, from: bd)
            return bMonth == selMonth && bDay == selDay
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        Text("공유 캘린더")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 30)
                        
                        Spacer()
                        
                        Button {
                            // selectedDate가 nil일 경우 오늘 날짜로 지정
                            if selectedDate == nil {
                                selectedDate = Date()
                            }
                            memoText = ""
                            selectedWriter = "Karina"
                            isMemoSheetPresented = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 40, height: 40)
                                .environment(\.colorScheme, .dark)
                        )
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                                .frame(width: 40, height: 40)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BackgroundColor").opacity(0.7))
                        .shadow(radius: 6)
                        .overlay(
                            CustomCalendarView(selectedDate: $selectedDate, cards: cards, memoDates: memoDates)
                                .padding()
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .frame(width: UIScreen.main.bounds.width * 0.88, height: 400)

                    if let date = selectedDate {
                        if birthdayCardsForSelectedDate.isEmpty && (memoStore.memos[date]?.isEmpty ?? true) {
                            VStack {
                                Image(systemName: "person.crop.circle.badge.xmark")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color("MainColor").opacity(0.8))
                                Text("생일인 친구가 없습니다.")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.headline)
                                    .padding(.top, 5)
                            }
                            .padding(.top, 30)
                        } else {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    if !birthdayCardsForSelectedDate.isEmpty {
                                        Text("오늘 생일인 친구")
                                            .font(.headline)
                                            .foregroundColor(Color("MainColor"))
                                        ForEach(birthdayCardsForSelectedDate, id: \.id) { card in
                                            HStack {
                                                Text(card.name)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                Spacer()
                                                Text(card.birthDate)
                                                    .foregroundColor(.white)
                                                    .font(.subheadline)
                                            }
                                            .shadow(radius: 2)
                                        }
                                    }
                                    
                                    if let memoList = memoStore.memos[date], !memoList.isEmpty {
                                        Divider()
                                            .padding(.vertical, 8)
                                        Text("공유 메모")
                                            .font(.headline)
                                            .foregroundColor(Color("MainColor"))
                                        ForEach(Array(memoList.enumerated()), id: \.offset) { _, memo in
                                            VStack(alignment: .leading) {
                                                Text(memo.text)
                                                    .foregroundColor(.black)
                                                    .padding(8)
                                                    .background(Color("MainColor").opacity(0.8))
                                                    .cornerRadius(10)
                                                
                                                Text("작성자: \(memo.writer)")
                                                    .foregroundColor(Color("MainColor").opacity(0.8))
                                                    .font(.footnote)
                                                    .padding(.bottom, 4)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(maxHeight: 200)
                        }
                    } else {
                        VStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 40))
                                .foregroundColor(Color("MainColor").opacity(0.8))
                            Text("날짜를 선택해주세요")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.headline)
                                .padding(.top, 5)
                        }
                        .padding(.top, 30)
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: $isMemoSheetPresented) {
                    if let date = selectedDate {
                        MemoSheetView(
                            isPresented: $isMemoSheetPresented,
                            selectedDate: Binding(
                                get: { date },
                                set: { newDate in
                                    selectedDate = newDate
                                }),
                            memoText: $memoText,
                            selectedWriter: $selectedWriter
                        )
                        .onDisappear {
                            let trimmedText = memoText.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmedText.isEmpty else { return }
                            
                            var memoList = memoStore.memos[date] ?? []
                            memoList.append((text: trimmedText, writer: selectedWriter))
                            memoStore.memos[date] = memoList
                        }
                    }
                }
            }
        }
    }
}

// MARK: - CardModel extension
extension CardModel {
    var birthDateAsDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: birthDate)
    }
}
