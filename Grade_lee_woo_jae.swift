// BoostCamp iOS 과제
// 이우재

import Foundation

//사용자 디렉토리에서 데이터 불러오기
let jsonPath = "/Users/LEE/students.json"
let content = FileManager.default.contents(atPath: jsonPath)

//json 배열에 삽입
let json:NSArray = try JSONSerialization.jsonObject(with: content!, options: .mutableContainers) as! NSArray

//dictionary타입으로 정리
var personList : Dictionary<String, [String:Double]> = [:] // 이름 : 과목별 점수

for data in json{
    
    let dic = data as! Dictionary<String,AnyObject>
    let name : String = dic["name"] as! String
    let grade = dic["grade"] as! Dictionary<String,Double>
    
    personList[name] = grade
    
}

//학생데이터 배열, 졸업명단 배열, 평균값 계산 준비
var personData : Dictionary<String,String> = [:] // 이름 : 학점
var graduatedList : Array<String> = [] // 수료생 명단
var meanSum : Double = 0 // 각 학생의 평균 점수 합

for person in personList{
    
    var sum : Double = 0
    var count : Double = 0 // 학생별 과목 개수
    var grade : String = ""
    graduatedList.append(person.key)
    
    //개인별 평균 계산과 평균 점수별 학점
    for subjects in person.value{
        count+=1
        sum+=subjects.value
    }
    
    let mean : Double = sum/count
    meanSum+=mean // 각 학생의 평균 점수 합하기
    
    if(mean>=90&&mean<=100){
        grade = "A"
    }
    else if(mean>=80){
        grade = "B"
    }
    else if(mean>=70){
        grade = "C"
    }
    else if(mean>=60){
        grade = "D"
        graduatedList.removeLast() // D학점 이하(평균 70점 미만)는 졸업명단에서 제거
    }
    else{
        grade = "F"
        graduatedList.removeLast()
    }
    
    personData[person.key] = grade
    
}

// 각 출력값을 result string에 저장
var result : String = ""
result+="성적결과표\n"

//전체 학생의 평균
let multiplier = pow(10.0, 2.0)
result+="\n전체 평균 : \(round(meanSum/Double(personList.count)*multiplier)/multiplier)\n" // 소수점 두자리 수까지

//개인별 학점
result+="\n개인별 학점\n"
for person in personData.sorted(by: { $0.0 < $1.0 }){ //abc내림차순(key값인 이름 기준)
    result+="\(person.key) \t: \(person.value)\n"
}

//수료생 명단
result+="\n수료생"
result+="\n"+graduatedList.sorted().joined(separator: ", ") //abc내림차순

//사용자 디렉터리의 result.txt로 결과 출력
let resultPath = "/Users/LEE/result.txt"
try result.write(toFile:resultPath, atomically:false, encoding: String.Encoding.utf8)
