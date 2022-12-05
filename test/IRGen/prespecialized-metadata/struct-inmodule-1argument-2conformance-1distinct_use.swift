// RUN: %swift -prespecialize-generic-metadata -target %module-target-future -emit-ir %s | %FileCheck %s -DINT=i%target-ptrsize -DALIGNMENT=%target-alignment

// REQUIRES: VENDOR=apple || OS=linux-gnu
// UNSUPPORTED: CPU=i386 && OS=ios
// UNSUPPORTED: CPU=armv7 && OS=ios
// UNSUPPORTED: CPU=armv7s && OS=ios

// CHECK: @"$sytN" = external{{( dllimport)?}} global %swift.full_type

// CHECK: @"$s4main5ValueVySiGMf" = linkonce_odr hidden constant <{
// CHECK-SAME:    i8**,
// CHECK-SAME:    [[INT]],
// CHECK-SAME:    %swift.type_descriptor*,
// CHECK-SAME:    %swift.type*,
// CHECK-SAME:    i8**,
// CHECK-SAME:    i8**,
// CHECK-SAME:    i32{{(, \[4 x i8\])?}},
// CHECK-SAME:    i64
// CHECK-SAME: }> <{
//                i8** @"$sB[[INT]]_WV",
//                i8** getelementptr inbounds (%swift.vwtable, %swift.vwtable* @"$s4main5ValueVySiGWV", i32 0, i32 0),
// CHECK-SAME:    [[INT]] 512,
// CHECK-SAME:    %swift.type_descriptor* bitcast ({{.+}}$s4main5ValueVMn{{.+}} to %swift.type_descriptor*),
// CHECK-SAME:    %swift.type* @"$sSiN",
// CHECK-SAME:    i8** getelementptr inbounds ([1 x i8*], [1 x i8*]* @"$sSi4main1PAAWP", i32 0, i32 0),
// CHECK-SAME:    i8** getelementptr inbounds ([1 x i8*], [1 x i8*]* @"$sSi4main1QAAWP", i32 0, i32 0),
// CHECK-SAME:    i32 0{{(, \[4 x i8\] zeroinitializer)?}},
// CHECK-SAME:    i64 3
// CHECK-SAME: }>, align [[ALIGNMENT]]

protocol P {}
protocol Q {}
extension Int : P {}
extension Int : Q {}
struct Value<First : P & Q> {
  let first: First
}

@inline(never)
func consume<T>(_ t: T) {
  withExtendedLifetime(t) { t in
  }
}

// CHECK: define hidden swiftcc void @"$s4main4doityyF"() #{{[0-9]+}} {
// CHECK:    call swiftcc void @"$s4main7consumeyyxlF"(%swift.opaque* noalias nocapture %{{[0-9]+}}, %swift.type* getelementptr inbounds (%swift.full_type, %swift.full_type* bitcast (<{ i8**, [[INT]], %swift.type_descriptor*, %swift.type*, i8**, i8**, i32{{(, \[4 x i8\])?}}, i64 }>* @"$s4main5ValueVySiGMf" to %swift.full_type*), i32 0, i32 1))
// CHECK: }
func doit() {
  consume( Value(first: 13) )
}
doit()

// CHECK: ; Function Attrs: noinline nounwind readnone
// CHECK: define hidden swiftcc %swift.metadata_response @"$s4main5ValueVMa"([[INT]] %0, %swift.type* %1, i8** %2, i8** %3) #{{[0-9]+}} {{(section)?.*}}{
// CHECK: entry:
// CHECK:   [[ERASED_TYPE:%[0-9]+]] = bitcast %swift.type* %1 to i8*
// CHECK:   [[ERASED_TABLE_1:%[0-9]+]] = bitcast i8** %2 to i8*
// CHECK:   [[ERASED_TABLE_2:%[0-9]+]] = bitcast i8** %3 to i8*
// CHECK:   {{%[0-9]+}} = call swiftcc %swift.metadata_response @__swift_instantiateCanonicalPrespecializedGenericMetadata([[INT]] %0, i8* [[ERASED_TYPE]], i8* [[ERASED_TABLE_1]], i8* [[ERASED_TABLE_2]], %swift.type_descriptor* bitcast ({{.+}}$s4main5ValueVMn{{.+}} to %swift.type_descriptor*), [[INT]]* @"$s4main5ValueVMz") #{{[0-9]+}}
// CHECK:   ret %swift.metadata_response {{%[0-9]+}}
// CHECK: }
