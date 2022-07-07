// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// const https = require("https");
// admin.initializeApp(functions.config().firebase);

// const offset = 8; // UTC+08:00
// const bucket = 'jodohmy.appspot.com';

// exports.notiStatus = functions.region('asia-southeast1').database.ref('Fixtures/{year}/{date}/{league}/time/{time}/{match}/fixture/statusshort')
//     .onUpdate( async (change, context) => {
    
//     // ============================= U P D A T E   S T A N D I N G S ============================
//     try {

//         // CUSTOM POINT
//         const customPoint = [{
//             clubId : 2524, // Perak
//             leagueId : 279,
//             season : 2022,
//             point : -9
//         }, {
//             clubId : 2519, // Melaka United
//             leagueId : 278,
//             season : 2021,
//             point : -3 
//         }];

//         const leagueId = context.params.league;
//         const year = context.params.year;
//         var listClub = [];
//         var pathS = 'Fixtures/' + year;
//         await admin.database().ref(pathS).once('value').then((snapshot) => {
//             if (snapshot.exists()) {
//                 snapshot.forEach((dataDate) => {
//                     if (dataDate.val()[leagueId] != null && dataDate.val()[leagueId]['time'] != null) {
//                         dataDate.child(leagueId).child('time').forEach((dataTime) => {
//                             dataTime.forEach((dataMatch) => {
//                                 var data = dataMatch.val();

//                                 var isAllow = true;
//                                 var round;
//                                 if (leagueId == 17 || leagueId == 18 || leagueId == 499 || leagueId == 911 || leagueId == 532) round = "Group Stage"; // GET ROUND STRING (ACL, AFC Cup, SEA)
//                                 else if (leagueId == 35) round = "3rd Round"; // Asian Cup - Kelayakan (2022)

//                                 if (round != null && data['fixture']['round'] != null && !data['fixture']['round'].includes(round))
//                                     isAllow = false;

//                                 if (isAllow && data['goals']['home'] != null && data['goals']['away'] != null && (data['fixture']['statusshort'] == "1H" || data['fixture']['statusshort'] == "2H" || data['fixture']['statusshort'] == "HT" || data['fixture']['statusshort'] == "FT")) {
//                                     var homeIndex = listClub.findIndex(e => e.clubId == data['teams']['home']['id']);
//                                     var awayIndex = listClub.findIndex(e => e.clubId == data['teams']['away']['id']);
                                    
//                                     if (homeIndex == -1) {
//                                         // initial value (new add)
//                                         var b = {
//                                             clubId: data['teams']['home']['id'],
//                                             b: data['goals']['away'],
//                                             j: data['goals']['home'],
//                                             k: data['goals']['home'] < data['goals']['away'] ? 1 : 0,
//                                             m: data['goals']['home'] > data['goals']['away'] ? 1 : 0,
//                                             mata: data['goals']['home'] > data['goals']['away'] ? 3 : data['goals']['home'] == data['goals']['away'] ? 1 : 0,
//                                             p: 1,
//                                             pj: data['goals']['home'] - data['goals']['away'],
//                                             s: data['goals']['home'] == data['goals']['away'] ? 1 : 0
//                                         }
//                                         listClub.push(b);
//                                     } else {
//                                         listClub[homeIndex].b = listClub[homeIndex].b + data['goals']['away'];
//                                         listClub[homeIndex].j = listClub[homeIndex].j + data['goals']['home'];
//                                         listClub[homeIndex].k = data['goals']['home'] < data['goals']['away'] ? listClub[homeIndex].k + 1 : listClub[homeIndex].k;
//                                         listClub[homeIndex].m = data['goals']['home'] > data['goals']['away'] ? listClub[homeIndex].m + 1 : listClub[homeIndex].m;
//                                         listClub[homeIndex].mata = data['goals']['home'] > data['goals']['away'] ? listClub[homeIndex].mata + 3 : data['goals']['home'] == data['goals']['away'] ? listClub[homeIndex].mata + 1 : listClub[homeIndex].mata;
//                                         listClub[homeIndex].p = listClub[homeIndex].p + 1;
//                                         listClub[homeIndex].pj = listClub[homeIndex].pj + (data['goals']['home'] - data['goals']['away']);
//                                         listClub[homeIndex].s = data['goals']['home'] == data['goals']['away'] ? listClub[homeIndex].s + 1 : listClub[homeIndex].s;
//                                     }


//                                     if (awayIndex == -1) {
//                                         // initial value (new add)
//                                         var b = {
//                                             clubId: data['teams']['away']['id'],
//                                             b: data['goals']['home'],
//                                             j: data['goals']['away'],
//                                             k: data['goals']['away'] < data['goals']['home'] ? 1 : 0,
//                                             m: data['goals']['away'] > data['goals']['home'] ? 1 : 0,
//                                             mata: data['goals']['away'] > data['goals']['home'] ? 3 : data['goals']['away'] == data['goals']['home'] ? 1 : 0,
//                                             p: 1,
//                                             pj: data['goals']['away'] - data['goals']['home'],
//                                             s: data['goals']['away'] == data['goals']['home'] ? 1 : 0
//                                         };
//                                         listClub.push(b);
//                                     } else {
//                                         listClub[awayIndex].b = listClub[awayIndex].b + data['goals']['home'];
//                                         listClub[awayIndex].j = listClub[awayIndex].j + data['goals']['away'];
//                                         listClub[awayIndex].k = data['goals']['away'] < data['goals']['home'] ? listClub[awayIndex].k + 1 : listClub[awayIndex].k;
//                                         listClub[awayIndex].m = data['goals']['away'] > data['goals']['home'] ? listClub[awayIndex].m + 1 : listClub[awayIndex].m;
//                                         listClub[awayIndex].mata = data['goals']['away'] > data['goals']['home'] ? listClub[awayIndex].mata + 3 : data['goals']['home'] == data['goals']['away'] ? listClub[awayIndex].mata + 1 : listClub[awayIndex].mata;
//                                         listClub[awayIndex].p = listClub[awayIndex].p + 1;
//                                         listClub[awayIndex].pj = listClub[awayIndex].pj + (data['goals']['away'] - data['goals']['home']);
//                                         listClub[awayIndex].s = data['goals']['home'] == data['goals']['away'] ? listClub[awayIndex].s + 1 : listClub[awayIndex].s;
//                                     }


//                                 }
                                
//                             });
//                         });
//                     }
//                 });

//             }
//         });

//         // CUSTOM POINT
//         try {
//             var index = 0;
//             listClub.forEach((e) => {
//                 customPoint.forEach((a) => {
//                     if (e.clubId == a.clubId && parseInt(year) == a.season && parseInt(leagueId) == a.leagueId) {
//                         listClub[index].mata = listClub[index].mata + a.point;
//                     }
//                 });
//                 index++;
//             });
//         } catch (e) {console.log("ERROR CUSTOM POINT : " + e);}

//         // listClub.forEach((e) => {
//         //     console.log(e.clubId + ' P:' + e.p + ' M:' + e.m + ' S:' + e.s + ' K:' + e.k + ' J-B:' + e.j + '-' + e.b + ' PJ:' + e.pj + ' Ma:' + e.mata);
//         // });

//         var pathStandings = 'Standings/' + year + '/' + leagueId + '/standings';

//         admin.database().ref(pathStandings).once('value').then((snapshot) => {
//             if (snapshot.exists()) {
//                 var groupIndex = 0;
//                 snapshot.forEach((group) => {
//                     var index = 0;
//                     group.forEach((e) => {
//                         listClub.forEach((a) => {
//                             if (a.clubId == e.val()['team']['id']) {
//                                 var pathEach = 'Standings/' + year + '/' + leagueId + '/standings/' + groupIndex.toString() + '/' + index.toString() + '/all';
//                                 admin.database().ref(pathEach).set(a);
//                             }
//                         });
//                         index++;
//                     });
//                     groupIndex++;
//                 });
//                 console.log("SUCCESSFULLY UPDATE STANDINGS : " + year + ' | ' + leagueId);
//             }
//         });
//     } catch (e) {console.log("ERROR UPDATE STANDINGS : " + e);}

//     // ============================= U P D A T E   S T A N D I N G S   E N D ============================




//     const ssBefore = change.before.val(); // Status short before changed
//     const ssAfter = change.after.val(); // Status short after changed

//     const ssReal = getRealSS(ssAfter); // Make sure ss is in [1H, HT, 2H, FT] only

//     const path = 'Fixtures/' + context.params.year + '/' + context.params.date
//                 + '/' + context.params.league + '/time/' + context.params.time + '/' + context.params.match;

//     var homeName;
//     var awayName;
//     var homeId;
//     var awayId;
//     var homeLogo;
//     var awayLogo;

//     var homeGoal;
//     var awayGoal;
//     var homePenGoal;
//     var awayPenGoal;
//     try {
//         await admin.database().ref(path).once('value').then((e) => {
//             if (e.exists) {
//                 homeName = e.val()['teams']['home']['name'];
//                 awayName = e.val()['teams']['away']['name'];

//                 homeId = e.val()['teams']['home']['id'];
//                 awayId = e.val()['teams']['away']['id'];

//                 homeGoal = e.val()['goals']['home'];
//                 awayGoal = e.val()['goals']['away'];
                
//                 if (e.val()['score'] != null && e.val()['score']['penalty'] != null && e.val()['score']['penalty']['home'] != null && e.val()['score']['penalty']['away'] != null) {
//                     homePenGoal = e.val()['score']['penalty']['home'];
//                     awayPenGoal = e.val()['score']['penalty']['away'];
//                 }

//                 homeLogo = e.val()['teams']['home']['logocustom'] ?? e.val()['teams']['home']['logo'];
//                 awayLogo = e.val()['teams']['away']['logocustom'] ?? e.val()['teams']['away']['logo'];
//             } else return null;
//         });
//     } catch (e) {return null;}

//     var statusPlay = getStatusPlay(ssBefore, ssAfter);
//     var bodyText = homeName + ' VS ' + awayName;
//     var bodyTextSubscriber = homeName + ' ' + homeGoal + ' - ' + awayGoal + ' ' + awayName;
//     if (ssAfter == "PEN" && homePenGoal != null && awayPenGoal != null) bodyTextSubscriber = homeName + ' ' + homeGoal + '(' + homePenGoal + ') - (' + awayPenGoal + ')' + awayGoal + ' ' + awayName;
//     if (statusPlay == null) return null;

//     // ========== Send notification based on 3 rules ==========
//     // Rule 1 - Check user's notification settings of specific club is enable (eg. 15minutes, 1H, HT, 2H, FT)
//     // Rule 2 - Check user's favorite club meets the current triggered match
//     // Rule 3 - Check user's timestamp token whether it's within 2 months before expired

//     const userDocs = await admin.firestore().collection('user').get();
//     var tokenListHome = [];
//     var tokenListAway = [];
//     var tokenListSubscriberHome = [];
//     var tokenListSubscriberAway = [];
//     userDocs.docs.forEach((e) => {
//         try {
//             if (e.data()['notification'] != null && e.data()['notification']['token'] != null) {
//                 var rule1 = false;
//                 var rule2 = false;
//                 var rule3 = false;
//                 var isHome = false;

//                 var token = e.data()['notification']['token'];
                
//                 try { // Rule 1 
//                     if ((e.data()['notification']['clubId'][homeId] != null && e.data()['notification']['clubId'][homeId][ssReal]) || (e.data()['notification']['clubId'][awayId] != null && e.data()['notification']['clubId'][awayId][ssReal])) {
//                         rule1 = true;
//                     }
//                 } catch (_) {}
//                 // OLD RULE
//                 // if (e.data()['notification'][ssReal] != null && e.data()['notification'][ssReal]) { // Rule 1 
//                 //     rule1 = true;
//                 //     //console.log("RULE 1 : TRUE");
//                 // }
//                 if (e.data()['clubId'] != null) { // Rule 2
//                     //console.log("RULE 2 CHECK : " + e.data()['clubId'] + " | " + homeId + " | " + awayId);
//                     e.data()['clubId'].forEach((id) => {
//                         if (id == homeId || id == awayId) {
//                             rule2 = true;
//                             //console.log("RULE 2 : TRUE");
//                             if (id == homeId)
//                                 isHome = true;
//                         }
//                     });
//                 }
//                 if (e.data()['notification']['timestamp'] != null) { // Rule 3
//                     var timestamp = e.data()['notification']['timestamp'].toDate();
//                     var nowDT = new Date();
//                     var Difference_In_Time = nowDT.getTime() - timestamp.getTime();
//                     var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
//                     //console.log("RULE 3 CHECK : " + timestamp + " | " + nowDT)
//                     //console.log("RULE 3 CHECKED : " + Difference_In_Days)
//                     if (Difference_In_Days < 60) {
//                         rule3 = true;
//                         //console.log("RULE 3 : TRUE");
//                     }
//                 }
                
//                 if (rule1 && rule2 && rule3) {
//                     if (isHome) {
//                         if (tokenListAway.includes(token) == false) { // Check if token already exist in AWAY
//                             if (e.data()['subscriber'] != null && e.data()['subscriber'])
//                                 tokenListSubscriberHome.push(token);
//                             else
//                                 tokenListHome.push(token);
//                         }
//                     }
//                     else {
//                         if (tokenListHome.includes(token) == false) { // Check if token already exist in HOME
//                             if (e.data()['subscriber'] != null && e.data()['subscriber'])
//                                 tokenListSubscriberAway.push(token);
//                             else
//                                 tokenListAway.push(token);
//                         }
//                     }
//                 }

//             }
//         } catch (err) {}
//     });
//     const userAnonDocs = await admin.firestore().collection('userAnonymous').get();
//     userAnonDocs.docs.forEach((e) => {
//         try {
//             if (e.data()['notification'] != null && e.data()['notification']['token'] != null) {
//                 var rule1 = false;
//                 var rule2 = false;
//                 var rule3 = false;
//                 var isHome = false;

//                 var token = e.data()['notification']['token'];

//                 try { // Rule 1 
//                     if ((e.data()['notification']['clubId'][homeId] != null && e.data()['notification']['clubId'][homeId][ssReal]) || (e.data()['notification']['clubId'][awayId] != null && e.data()['notification']['clubId'][awayId][ssReal])) {
//                         rule1 = true;
//                     }
//                 } catch (_) {}
//                 // OLD RULE
//                 // if (e.data()['notification'][ssReal] != null && e.data()['notification'][ssReal]) { // Rule 1 
//                 //     rule1 = true;
//                 //     //console.log("RULE 1 : TRUE");
//                 // }
//                 if (e.data()['clubId'] != null) { // Rule 2
//                     //console.log("RULE 2 CHECK : " + e.data()['clubId'] + " | " + homeId + " | " + awayId);
//                     e.data()['clubId'].forEach((id) => {
//                         if (id == homeId || id == awayId) {
//                             rule2 = true;
//                             //console.log("RULE 2 : TRUE");
//                             if (id == homeId)
//                                 isHome = true;
//                         }
//                     });
//                 }
//                 if (e.data()['notification']['timestamp'] != null) { // Rule 3
//                     var timestamp = e.data()['notification']['timestamp'].toDate();
//                     var nowDT = new Date();
//                     var Difference_In_Time = nowDT.getTime() - timestamp.getTime();
//                     var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
//                     //console.log("RULE 3 CHECK : " + timestamp + " | " + nowDT)
//                     //console.log("RULE 3 CHECKED : " + Difference_In_Days)
//                     if (Difference_In_Days < 90) {
//                         rule3 = true;
//                         //console.log("RULE 3 : TRUE");
//                     }
//                 }
                
//                 if (rule1 && rule2 && rule3) {
//                     if (isHome) {
//                         if (tokenListAway.includes(token) == false) { // Check if token already exist in AWAY
//                             if (e.data()['subscriber'] != null && e.data()['subscriber'])
//                                 tokenListSubscriberHome.push(token);
//                             else
//                                 tokenListHome.push(token);
//                         }
//                     }
//                     else {
//                         if (tokenListHome.includes(token) == false) { // Check if token already exist in HOME
//                             if (e.data()['subscriber'] != null && e.data()['subscriber'])
//                                 tokenListSubscriberAway.push(token);
//                             else
//                                 tokenListAway.push(token);
//                         }
//                     }
//                 }

//             }
//         } catch (err) {}
//     });

//     tokenListHome = removeDuplicates(tokenListHome);
//     tokenListAway = removeDuplicates(tokenListAway);

//     const payloadHome = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : statusPlay,
//             body : bodyText,
//             badge : '1',
//             sound : 'default',
//             image: homeLogo
//         }
//     };
//     const payloadAway = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : statusPlay,
//             body : bodyText,
//             badge : '1',
//             sound : 'default',
//             image: awayLogo
//         }
//     };
//     const payloadSubscriberHome = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : statusPlay,
//             body : bodyTextSubscriber,
//             badge : '1',
//             sound : 'default',
//             image: homeLogo
//         }
//     };
//     const payloadSubscriberAway = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : statusPlay,
//             body : bodyTextSubscriber,
//             badge : '1',
//             sound : 'default',
//             image: awayLogo
//         }
//     };
//     const options = {
//         priority: 'high',
//         content_available: true,
//         mutable_content: true
//     };

//     // ===========================================================================

//     if (tokenListHome.length > 0) {
//         console.log('SENDING TO DEVICE HOME : ' + tokenListHome.length);
//         await admin.messaging().sendToDevice(tokenListHome, payloadHome, options);
//     } else {
//         console.log('No token available for HOME');
//     }

//     if (tokenListAway.length > 0) {
//         console.log('SENDING TO DEVICE AWAY : ' + tokenListAway.length);
//         await admin.messaging().sendToDevice(tokenListAway, payloadAway, options);
//     } else {
//         console.log('No token available for AWAY');
//     }

//     // ===========================================================================

//     if (tokenListSubscriberHome.length > 0) {
//         console.log('SENDING TO DEVICE SUBSCRIBER HOME : ' + tokenListSubscriberHome.length);
//         await admin.messaging().sendToDevice(tokenListSubscriberHome, payloadSubscriberHome, options);
//     } else {
//         console.log('No token available for SUBSCRIBER AWAY');
//     }

//     if (tokenListSubscriberAway.length > 0) {
//         console.log('SENDING TO DEVICE SUBSCRIBER AWAY : ' + tokenListSubscriberAway.length);
//         await admin.messaging().sendToDevice(tokenListSubscriberAway, payloadSubscriberAway, options);
//     } else {
//         console.log('No token available for SUBSCRIBER AWAY');
//     }

//     // ===========================================================================

//     return null;





//     function removeDuplicates(arr) {
//         return arr.filter((item, index) => arr.indexOf(item) === index);
//     }

//     function getRealSS(ssAfter) {
//         if (ssAfter == "AET" || ssAfter == "PEN") return "FT";
//         else if (ssAfter == "P") return "2H";
//         return ssAfter;
//     }

//     function getStatusPlay(ssBefore, ssAfter) {
//         if (ssBefore == "NS" && ssAfter == "1H") return "Perlawanan Bermula!"; // 1H
//         else if (ssBefore == "1H" && ssAfter == "HT") return "Separuh Masa"; // HT
//         else if (ssBefore == "HT" && ssAfter == "2H") return "Separuh Masa Kedua Bermula!"; // 2H
//         else if (ssAfter == "FT") return "Masa Penuh"; // FT
//         else if (ssAfter == "AET") return "Masa Penuh (Masa Tambahan)"; // FT
//         else if (ssAfter == "PEN") return "Masa Penuh (Sepakan Penalti)"; // FT
//         else if (ssAfter == "P") return "Sepakan Penalti Bermula!"; // 2H
//         else return null;
//     }
// });

// exports.noti15minutes = functions.region('asia-southeast1').database.ref('Fixtures/{year}/{date}/{league}/time/{time}/{match}/fixture/15minutes')
//     .onCreate( async (snap, context) => {

//     const path = 'Fixtures/' + context.params.year + '/' + context.params.date
//                 + '/' + context.params.league + '/time/' + context.params.time + '/' + context.params.match;

//     var homeName;
//     var awayName;
//     var homeId;
//     var awayId;
//     var homeLogo;
//     var awayLogo;
//     try {
//         await admin.database().ref(path).once('value').then((e) => {
//             if (e.exists) {
//                 //console.log("3 : " + e.val()['teams']['home']['name']);
//                 homeName = e.val()['teams']['home']['name'];
//                 awayName = e.val()['teams']['away']['name'];

//                 homeId = e.val()['teams']['home']['id'];
//                 awayId = e.val()['teams']['away']['id'];

//                 homeLogo = e.val()['teams']['home']['logocustom'] ?? e.val()['teams']['home']['logo'];
//                 awayLogo = e.val()['teams']['away']['logocustom'] ?? e.val()['teams']['away']['logo'];
//             } else return null;
//         });
//     } catch (e) {return null;}


//     const userDocs = await admin.firestore().collection('user').get();
//     var tokenListHome = [];
//     var tokenListAway = [];
//     userDocs.docs.forEach((e) => {
//         try {
//             if (e.data()['notification'] != null && e.data()['notification']['token'] != null) {
//                 var rule1 = false;
//                 var rule2 = false;
//                 var rule3 = false;
//                 var isHome = false;

//                 var token = e.data()['notification']['token'];

//                 try { // Rule 1 
//                     if ((e.data()['notification']['clubId'][homeId] != null && e.data()['notification']['clubId'][homeId]['15minutes']) || (e.data()['notification']['clubId'][awayId] != null && e.data()['notification']['clubId'][awayId]['15minutes'])) {
//                         rule1 = true;
//                     }
//                 } catch (_) {}
//                 // if (e.data()['notification']['15minutes'] != null && e.data()['notification']['15minutes']) { // Rule 1 
//                 //     rule1 = true;
//                 // }
//                 if (e.data()['clubId'] != null) { // Rule 2
//                     e.data()['clubId'].forEach((id) => {
//                         if (id == homeId || id == awayId) {
//                             rule2 = true;
//                             if (id == homeId)
//                                 isHome = true;
//                         }
//                     });
//                 }
//                 if (e.data()['notification']['timestamp'] != null) { // Rule 3
//                     var timestamp = e.data()['notification']['timestamp'].toDate();
//                     var nowDT = new Date();
//                     var Difference_In_Time = nowDT.getTime() - timestamp.getTime();
//                     var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
//                     if (Difference_In_Days < 60) {
//                         rule3 = true;
//                     }
//                 }
                
//                 if (rule1 && rule2 && rule3) {
//                     if (isHome) {
//                         if (tokenListAway.includes(token) == false) // Check if token already exist in AWAY
//                             tokenListHome.push(token);
//                     }
//                     else {
//                         if (tokenListHome.includes(token) == false) // Check if token already exist in HOME
//                             tokenListAway.push(token);
//                     }
//                 }

//             }
//         } catch (err) {}
//     });
//     const userAnonDocs = await admin.firestore().collection('userAnonymous').get();
//     userAnonDocs.docs.forEach((e) => {
//         try {
//             if (e.data()['notification'] != null && e.data()['notification']['token'] != null) {
//                 var rule1 = false;
//                 var rule2 = false;
//                 var rule3 = false;
//                 var isHome = false;

//                 var token = e.data()['notification']['token'];

//                 try { // Rule 1 
//                     if ((e.data()['notification']['clubId'][homeId] != null && e.data()['notification']['clubId'][homeId]['15minutes']) || (e.data()['notification']['clubId'][awayId] != null && e.data()['notification']['clubId'][awayId]['15minutes'])) {
//                         rule1 = true;
//                     }
//                 } catch (_) {}
//                 // if (e.data()['notification']['15minutes'] != null && e.data()['notification']['15minutes']) { // Rule 1 
//                 //     rule1 = true;
//                 // }
//                 if (e.data()['clubId'] != null) { // Rule 2
//                     e.data()['clubId'].forEach((id) => {
//                         if (id == homeId || id == awayId) {
//                             rule2 = true;
//                             if (id == homeId)
//                                 isHome = true;
//                         }
//                     });
//                 }
//                 if (e.data()['notification']['timestamp'] != null) { // Rule 3
//                     var timestamp = e.data()['notification']['timestamp'].toDate();
//                     var nowDT = new Date();
//                     var Difference_In_Time = nowDT.getTime() - timestamp.getTime();
//                     var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
//                     if (Difference_In_Days < 90) {
//                         rule3 = true;
//                     }
//                 }
                
//                 if (rule1 && rule2 && rule3) {
//                     if (isHome) {
//                         if (tokenListAway.includes(token) == false) // Check if token already exist in AWAY
//                             tokenListHome.push(token);
//                     }
//                     else {
//                         if (tokenListHome.includes(token) == false) // Check if token already exist in HOME
//                             tokenListAway.push(token);
//                     }
//                 }

//             }
//         } catch (err) {}
//     });

//     tokenListHome = removeDuplicates(tokenListHome);
//     tokenListAway = removeDuplicates(tokenListAway);

//     const payloadHome = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : homeName + ' VS ' + awayName,
//             body : 'Perlawanan bermula dalam 15 minit!',
//             badge : '1',
//             sound : 'default',
//             image: homeLogo
//         }
//     };
//     const payloadAway = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : homeName + ' VS ' + awayName,
//             body : 'Perlawanan bermula dalam 15 minit!',
//             badge : '1',
//             sound : 'default',
//             image: awayLogo
//         }
//     };
//     const options = {
//         priority: 'high',
//         content_available: true,
//         mutable_content: true
//     };

//     if (tokenListHome.length > 0) {
//         console.log('15 MINUTES SENDING TO DEVICE HOME : ' + tokenListHome.length);
//         await admin.messaging().sendToDevice(tokenListHome, payloadHome, options);
//     } else {
//         console.log('15 MINUTES No token available for HOME');
//     }

//     if (tokenListAway.length > 0) {
//         console.log('15 MINUTES SENDING TO DEVICE AWAY : ' + tokenListAway.length);
//         await admin.messaging().sendToDevice(tokenListAway, payloadAway, options);
//     } else {
//         console.log('15 MINUTES No token available for AWAY');
//     }

//     return null;

//     function removeDuplicates(arr) {
//         return arr.filter((item, index) => arr.indexOf(item) === index);
//     }

// });

// exports.notiGoals = functions.region('asia-southeast1').database.ref('Fixtures/{year}/{date}/{league}/time/{time}/{match}/goals')
//     .onUpdate( async (change, context) => {

//     // ============================= U P D A T E   S T A N D I N G S ============================
//     try {

//         // CUSTOM POINT
//         const customPoint = [{
//             clubId : 2524, // Perak
//             leagueId : 279,
//             season : 2022,
//             point : -9
//         }, {
//             clubId : 2519, // Melaka United
//             leagueId : 278,
//             season : 2021,
//             point : -3 
//         }];

//         const leagueId = context.params.league;
//         const year = context.params.year;
//         var listClub = [];
//         var pathS = 'Fixtures/' + year;
//         await admin.database().ref(pathS).once('value').then((snapshot) => {
//             if (snapshot.exists()) {
//                 snapshot.forEach((dataDate) => {
//                     if (dataDate.val()[leagueId] != null && dataDate.val()[leagueId]['time'] != null) {
//                         dataDate.child(leagueId).child('time').forEach((dataTime) => {
//                             dataTime.forEach((dataMatch) => {
//                                 var data = dataMatch.val();

//                                 var isAllow = true;
//                                 var round;
//                                 if (leagueId == 17 || leagueId == 18 || leagueId == 499 || leagueId == 911 || leagueId == 532) round = "Group Stage"; // GET ROUND STRING (ACL, AFC Cup, SEA)
//                                 else if (leagueId == 35) round = "3rd Round"; // Asian Cup - Kelayakan (2022)

//                                 if (round != null && data['fixture']['round'] != null && !data['fixture']['round'].includes(round))
//                                     isAllow = false;

//                                 if (isAllow && data['goals']['home'] != null && data['goals']['away'] != null && (data['fixture']['statusshort'] == "1H" || data['fixture']['statusshort'] == "2H" || data['fixture']['statusshort'] == "HT" || data['fixture']['statusshort'] == "FT")) {
//                                     var homeIndex = listClub.findIndex(e => e.clubId == data['teams']['home']['id']);
//                                     var awayIndex = listClub.findIndex(e => e.clubId == data['teams']['away']['id']);
                                    
//                                     if (homeIndex == -1) {
//                                         // initial value (new add)
//                                         var b = {
//                                             clubId: data['teams']['home']['id'],
//                                             b: data['goals']['away'],
//                                             j: data['goals']['home'],
//                                             k: data['goals']['home'] < data['goals']['away'] ? 1 : 0,
//                                             m: data['goals']['home'] > data['goals']['away'] ? 1 : 0,
//                                             mata: data['goals']['home'] > data['goals']['away'] ? 3 : data['goals']['home'] == data['goals']['away'] ? 1 : 0,
//                                             p: 1,
//                                             pj: data['goals']['home'] - data['goals']['away'],
//                                             s: data['goals']['home'] == data['goals']['away'] ? 1 : 0
//                                         }
//                                         listClub.push(b);
//                                     } else {
//                                         listClub[homeIndex].b = listClub[homeIndex].b + data['goals']['away'];
//                                         listClub[homeIndex].j = listClub[homeIndex].j + data['goals']['home'];
//                                         listClub[homeIndex].k = data['goals']['home'] < data['goals']['away'] ? listClub[homeIndex].k + 1 : listClub[homeIndex].k;
//                                         listClub[homeIndex].m = data['goals']['home'] > data['goals']['away'] ? listClub[homeIndex].m + 1 : listClub[homeIndex].m;
//                                         listClub[homeIndex].mata = data['goals']['home'] > data['goals']['away'] ? listClub[homeIndex].mata + 3 : data['goals']['home'] == data['goals']['away'] ? listClub[homeIndex].mata + 1 : listClub[homeIndex].mata;
//                                         listClub[homeIndex].p = listClub[homeIndex].p + 1;
//                                         listClub[homeIndex].pj = listClub[homeIndex].pj + (data['goals']['home'] - data['goals']['away']);
//                                         listClub[homeIndex].s = data['goals']['home'] == data['goals']['away'] ? listClub[homeIndex].s + 1 : listClub[homeIndex].s;
//                                     }


//                                     if (awayIndex == -1) {
//                                         // initial value (new add)
//                                         var b = {
//                                             clubId: data['teams']['away']['id'],
//                                             b: data['goals']['home'],
//                                             j: data['goals']['away'],
//                                             k: data['goals']['away'] < data['goals']['home'] ? 1 : 0,
//                                             m: data['goals']['away'] > data['goals']['home'] ? 1 : 0,
//                                             mata: data['goals']['away'] > data['goals']['home'] ? 3 : data['goals']['away'] == data['goals']['home'] ? 1 : 0,
//                                             p: 1,
//                                             pj: data['goals']['away'] - data['goals']['home'],
//                                             s: data['goals']['away'] == data['goals']['home'] ? 1 : 0
//                                         };
//                                         listClub.push(b);
//                                     } else {
//                                         listClub[awayIndex].b = listClub[awayIndex].b + data['goals']['home'];
//                                         listClub[awayIndex].j = listClub[awayIndex].j + data['goals']['away'];
//                                         listClub[awayIndex].k = data['goals']['away'] < data['goals']['home'] ? listClub[awayIndex].k + 1 : listClub[awayIndex].k;
//                                         listClub[awayIndex].m = data['goals']['away'] > data['goals']['home'] ? listClub[awayIndex].m + 1 : listClub[awayIndex].m;
//                                         listClub[awayIndex].mata = data['goals']['away'] > data['goals']['home'] ? listClub[awayIndex].mata + 3 : data['goals']['home'] == data['goals']['away'] ? listClub[awayIndex].mata + 1 : listClub[awayIndex].mata;
//                                         listClub[awayIndex].p = listClub[awayIndex].p + 1;
//                                         listClub[awayIndex].pj = listClub[awayIndex].pj + (data['goals']['away'] - data['goals']['home']);
//                                         listClub[awayIndex].s = data['goals']['home'] == data['goals']['away'] ? listClub[awayIndex].s + 1 : listClub[awayIndex].s;
//                                     }


//                                 }
                                
//                             });
//                         });
//                     }
//                 });

//             }
//         });

//         // CUSTOM POINT
//         try {
//             var index = 0;
//             listClub.forEach((e) => {
//                 customPoint.forEach((a) => {
//                     if (e.clubId == a.clubId && parseInt(year) == a.season && parseInt(leagueId) == a.leagueId) {
//                         listClub[index].mata = listClub[index].mata + a.point;
//                     }
//                 });
//                 index++;
//             });
//         } catch (e) {console.log("ERROR CUSTOM POINT : " + e);}

//         // listClub.forEach((e) => {
//         //     console.log(e.clubId + ' P:' + e.p + ' M:' + e.m + ' S:' + e.s + ' K:' + e.k + ' J-B:' + e.j + '-' + e.b + ' PJ:' + e.pj + ' Ma:' + e.mata);
//         // });

//         var pathStandings = 'Standings/' + year + '/' + leagueId + '/standings';

//         admin.database().ref(pathStandings).once('value').then((snapshot) => {
//             if (snapshot.exists()) {
//                 var groupIndex = 0;
//                 snapshot.forEach((group) => {
//                     var index = 0;
//                     group.forEach((e) => {
//                         listClub.forEach((a) => {
//                             if (a.clubId == e.val()['team']['id']) {
//                                 var pathEach = 'Standings/' + year + '/' + leagueId + '/standings/' + groupIndex.toString() + '/' + index.toString() + '/all';
//                                 admin.database().ref(pathEach).set(a);
//                             }
//                         });
//                         index++;
//                     });
//                     groupIndex++;
//                 });
//                 console.log("SUCCESSFULLY UPDATE STANDINGS : " + year + ' | ' + leagueId);
//             }
//         });
//     } catch (e) {console.log("ERROR UPDATE STANDINGS : " + e);}

//     // ============================= U P D A T E   S T A N D I N G S   E N D ============================

//     const path = 'Fixtures/' + context.params.year + '/' + context.params.date
//                 + '/' + context.params.league + '/time/' + context.params.time + '/' + context.params.match;

//     var homeName;
//     var awayName;
//     var homeId;
//     var awayId;
//     var homeLogo;
//     var awayLogo;

//     var elapsed;
    
//     var isLive;
//     try {
//         await admin.database().ref(path).once('value').then((e) => {
//             if (e.exists) {
//                 //console.log("3 : " + e.val()['teams']['home']['name']);
//                 homeName = e.val()['teams']['home']['name'];
//                 awayName = e.val()['teams']['away']['name'];

//                 homeId = e.val()['teams']['home']['id'];
//                 awayId = e.val()['teams']['away']['id'];

//                 elapsed = e.val()['fixture']['elapsed'];

//                 homeLogo = e.val()['teams']['home']['logocustom'] ?? e.val()['teams']['home']['logo'];
//                 awayLogo = e.val()['teams']['away']['logocustom'] ?? e.val()['teams']['away']['logo'];
            
//                 isLive = e.val()['fixture']['statusshort'];
//             } else return null;
//         });
//     } catch (e) {return null;}
//     console.log("IS LIVE : " + isLive);
//     if (isLive != "1H" && isLive != "HT" && isLive != "2H" && isLive != "ET") return null;


//     const userDocs = await admin.firestore().collection('user').get();
//     var tokenListHome = [];
//     var tokenListAway = [];
//     var tokenListSubscriberHome = [];
//     var tokenListSubscriberAway = [];
//     userDocs.docs.forEach((e) => {
//         try {
//             if (e.data()['notification'] != null && e.data()['notification']['token'] != null) {
//                 var rule1 = false;
//                 var rule2 = false;
//                 var rule3 = false;
//                 var isHome = false;

//                 var token = e.data()['notification']['token'];

//                 try { // Rule 1 
//                     if ((e.data()['notification']['clubId'][homeId] != null && e.data()['notification']['clubId'][homeId]['goal']) || (e.data()['notification']['clubId'][awayId] != null && e.data()['notification']['clubId'][awayId]['goal'])) {
//                         rule1 = true;
//                     }
//                 } catch (_) {}
//                 // if (e.data()['notification']['goal'] != null && e.data()['notification']['goal']) { // Rule 1 
//                 //     rule1 = true;
//                 // }
//                 if (e.data()['clubId'] != null) { // Rule 2
//                     e.data()['clubId'].forEach((id) => {
//                         if (id == homeId || id == awayId) {
//                             rule2 = true;
//                             if (id == homeId)
//                                 isHome = true;
//                         }
//                     });
//                 }
//                 if (e.data()['notification']['timestamp'] != null) { // Rule 3
//                     var timestamp = e.data()['notification']['timestamp'].toDate();
//                     var nowDT = new Date();
//                     var Difference_In_Time = nowDT.getTime() - timestamp.getTime();
//                     var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
//                     if (Difference_In_Days < 60) {
//                         rule3 = true;
//                     }
//                 }
                
//                 if (rule1 && rule2 && rule3) {
//                     if (isHome) {
//                         if (tokenListAway.includes(token) == false) { // Check if token already exist in AWAY
//                             if (e.data()['subscriber'] != null && e.data()['subscriber'])
//                                 tokenListSubscriberHome.push(token);
//                             else
//                                 tokenListHome.push(token);
//                         }
//                     }
//                     else {
//                         if (tokenListHome.includes(token) == false) { // Check if token already exist in HOME
//                             if (e.data()['subscriber'] != null && e.data()['subscriber'])
//                                 tokenListSubscriberAway.push(token);
//                             else
//                                 tokenListAway.push(token);
//                         }
//                     }
//                 }

//             }
//         } catch (err) {}
//     });
//     const userAnonDocs = await admin.firestore().collection('userAnonymous').get();
//     userAnonDocs.docs.forEach((e) => {
//         try {
//             if (e.data()['notification'] != null && e.data()['notification']['token'] != null) {
//                 var rule1 = false;
//                 var rule2 = false;
//                 var rule3 = false;
//                 var isHome = false;

//                 var token = e.data()['notification']['token'];

//                 try { // Rule 1 
//                     if ((e.data()['notification']['clubId'][homeId] != null && e.data()['notification']['clubId'][homeId]['goal']) || (e.data()['notification']['clubId'][awayId] != null && e.data()['notification']['clubId'][awayId]['goal'])) {
//                         rule1 = true;
//                     }
//                 } catch (_) {}
//                 // if (e.data()['notification']['goal'] != null && e.data()['notification']['goal']) { // Rule 1 
//                 //     rule1 = true;
//                 // }
//                 if (e.data()['clubId'] != null) { // Rule 2
//                     e.data()['clubId'].forEach((id) => {
//                         if (id == homeId || id == awayId) {
//                             rule2 = true;
//                             if (id == homeId)
//                                 isHome = true;
//                         }
//                     });
//                 }
//                 if (e.data()['notification']['timestamp'] != null) { // Rule 3
//                     var timestamp = e.data()['notification']['timestamp'].toDate();
//                     var nowDT = new Date();
//                     var Difference_In_Time = nowDT.getTime() - timestamp.getTime();
//                     var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
//                     if (Difference_In_Days < 90) {
//                         rule3 = true;
//                     }
//                 }
                
//                 if (rule1 && rule2 && rule3) {
//                     if (isHome) {
//                         if (tokenListAway.includes(token) == false) { // Check if token already exist in AWAY
//                             if (e.data()['subscriber'] != null && e.data()['subscriber'])
//                                 tokenListSubscriberHome.push(token);
//                             else
//                                 tokenListHome.push(token);
//                         }
//                     }
//                     else {
//                         if (tokenListHome.includes(token) == false) { // Check if token already exist in HOME
//                             if (e.data()['subscriber'] != null && e.data()['subscriber'])
//                                 tokenListSubscriberAway.push(token);
//                             else
//                                 tokenListAway.push(token);
//                         }
//                     }
//                 }

//             }
//         } catch (err) {}
//     });

//     tokenListHome = removeDuplicates(tokenListHome);
//     tokenListAway = removeDuplicates(tokenListAway);

//     if (elapsed == null || elapsed == "null")
//         elapsed = "";
    
//     var image = homeLogo;

//     var isHomeGoal = false;
//     if (change.after.val()['home'] > change.before.val()['home']) {
//         isHomeGoal = true;
//         console.log("IS HOME GOAL : " + isHomeGoal);
//     }
//     var isAwayGoal = false;
//     if (change.after.val()['away'] > change.before.val()['away']) {
//         isAwayGoal = true;
//         image = awayLogo;
//         console.log("IS AWAY GOAL : " + isAwayGoal);
//     }
    
//     if (!isHomeGoal && !isAwayGoal) return null; // If goals update is 'goal correction'
    
//     var title = "Gol! Minit ke-" + elapsed;
//     if (elapsed == "") title = "Gol!"
//     var bodySubscriber = homeName + ' VS ' + awayName;

//     if (isHomeGoal) 
//         bodySubscriber = homeName + ' [' + change.after.val()['home'] + '] - ' + change.after.val()['away'] + ' ' + awayName;
//     else
//         bodySubscriber = homeName + ' ' + change.after.val()['home'] + ' - [' + change.after.val()['away'] + '] ' + awayName;

//     const payloadHome = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : title,
//             body : homeName + ' VS ' + awayName,
//             badge : '1',
//             sound : 'default',
//             image: image
//         }
//     };
//     const payloadAway = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : title,
//             body : homeName + ' VS ' + awayName,
//             badge : '1',
//             sound : 'default',
//             image: image
//         }
//     };
//     const payloadSubscriberHome = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : title,
//             body : bodySubscriber,
//             badge : '1',
//             sound : 'default',
//             image: image
//         }
//     };
//     const payloadSubscriberAway = {
//         notification: {
//             android_channel_id : "skormas_channel",
//             priority : "high",
//             title : title,
//             body : bodySubscriber,
//             badge : '1',
//             sound : 'default',
//             image: image
//         }
//     };
//     const options = {
//         priority: 'high',
//         content_available: true,
//         mutable_content: true
//     };

//     // ===========================================================================

//     if (tokenListHome.length > 0) {
//         console.log('GOALS SENDING TO DEVICE HOME : ' + tokenListHome.length);
//         await admin.messaging().sendToDevice(tokenListHome, payloadHome, options);
//     } else {
//         console.log('GOALS No token available for HOME');
//     }

//     if (tokenListAway.length > 0) {
//         console.log('GOALS SENDING TO DEVICE AWAY : ' + tokenListAway.length);
//         await admin.messaging().sendToDevice(tokenListAway, payloadAway, options);
//     } else {
//         console.log('GOALS No token available for AWAY');
//     }

//     // ===========================================================================

//     if (tokenListSubscriberHome.length > 0) {
//         console.log('GOALS SENDING TO DEVICE SUBSCRIBER HOME : ' + tokenListSubscriberHome.length);
//         await admin.messaging().sendToDevice(tokenListSubscriberHome, payloadSubscriberHome, options);
//     } else {
//         console.log('GOALS No token available for SUBSCRIBER HOME');
//     }

//     if (tokenListSubscriberAway.length > 0) {
//         console.log('GOALS SENDING TO DEVICE SUBSCRIBER AWAY : ' + tokenListSubscriberAway.length);
//         await admin.messaging().sendToDevice(tokenListSubscriberAway, payloadSubscriberAway, options);
//     } else {
//         console.log('GOALS No token available for SUBSCRIBER AWAY');
//     }

//     // ===========================================================================

//     return null;

//     function removeDuplicates(arr) {
//         return arr.filter((item, index) => arr.indexOf(item) === index);
//     }

// });

// // When 'time' is deleted, remove whole day
// exports.removeWholeDay = functions.region('asia-southeast1').database.ref('Fixtures/{year}/{date}/{league}/time')
//     .onDelete( async (snap, context) => {
    
//     const path = 'Fixtures/' + context.params.year + '/' + context.params.date
//                 + '/' + context.params.league;

//     admin.database().ref(path).set({});
// });

// exports.removeOldToken = functions.region('asia-southeast1').firestore.document('{userType}/{userId}').onCreate( async (snap, context) => {
//     try {
//         if ((context.params.userType == "user" || context.params.userType == "userAnonymous") && snap.data()['notification'] != null && snap.data()['notification']['token'] != null) {
//             const token = snap.data()['notification']['token'];

//             const userDocs = await admin.firestore().collection('user').get();
//             userDocs.docs.forEach((e) => {
//                 if (e.id != context.params.userId && e.data()['notification'] != null && e.data()['notification']['token'] != null && e.data()['notification']['token'] == token) {
//                     admin.firestore().collection('user').doc(e.id).update({
//                         'notification.token' : null,
//                     });
//                     console.log("TOKEN HAS BEEN REMOVED (user) : " + e.id); 
//                 }
//             });

//             const userAnonDocs = await admin.firestore().collection('userAnonymous').get();
//             userAnonDocs.docs.forEach((e) => {
//                 if (e.id != context.params.userId && e.data()['notification'] != null && e.data()['notification']['token'] != null && e.data()['notification']['token'] == token) {
//                     admin.firestore().collection('userAnonymous').doc(e.id).update({
//                         'notification.token' : null,
//                     });
//                     console.log("TOKEN HAS BEEN REMOVED (userAnonymous) : " + e.id); 
//                 }
//             });
//         }
//     } catch (e) {console.log("ERROR : " + e);}
//     return null;
// });

// exports.upcomingFixtures = functions.region('asia-southeast1').pubsub.schedule("every day 03:00").timeZone('Asia/Kuala_Lumpur').onRun(async () => {
      
//     const optionsFormat = { year: 'numeric', month: 'numeric', day: 'numeric' };
        
//     try {
//         //let nowDT = Date.now();
//         const nowDT = new Date();
//         const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

//         const nowTrueDTfrom = new Date();
//         nowTrueDTfrom.setDate(nowDT.getDate()); // From (1 day after current DT)
//         const from = new Date(nowTrueDTfrom).toLocaleDateString('af-ZA', optionsFormat); // 2021-10-06
        
//         const nowTrueDTto = new Date(); 
//         nowTrueDTto.setDate(nowDT.getDate() + 365); // To (360 days after current DT)
//         const to = new Date(nowTrueDTto).toLocaleDateString('af-ZA', optionsFormat); // 2021-10-06

//         // =========================== THIS YEAR ============================
//         var dataThisYear; // Snapshot
//         const pathDataThisYear = 'Fixtures/' + nowDT.getFullYear();
//         await admin.database().ref(pathDataThisYear).once('value').then((snapshot) => {
//             if (snapshot.exists()) {
//                 dataThisYear = snapshot;
//             }
//         });

//         var leagueList; // List
//         await admin.database().ref('Update/league').once('value').then((snapshot) => {
//             if (snapshot.exists()) {
//                 leagueList = snapshot.val();
//             }
//         });

//         console.log("Number of league will update : " + leagueList.length);

//         for(let x=0; x<leagueList.length; x++) {
        
//             var leagueId = leagueList[x]['id'];
//             var trueSeason = leagueList[x]['season'] == null ? nowDT.getFullYear() : nowDT.getFullYear() + leagueList[x]['season'];

//             const optionsHttp = {
//                 hostname: hostName,
//                 path: '/v3/fixtures?league='+leagueId+'&season='+trueSeason+'&from='+from+'&to='+to,
//                 headers: headers
//             }

//             https.get(optionsHttp, async (res) => {
//                 res.setEncoding("utf8");
//                 var body = "";
//                 res.on("data", data => {
//                     body += data;
//                 });
//                 res.on("end", async () => {

//                     var responseK = JSON.parse(body)['response']; // string to Object/List/Array
//                     var responseKJson = JSON.stringify(responseK); // vice versa

//                     var response = JSON.parse(responseKJson);

//                     for(let i=0; i<response.length; i++) {

                        
//                         try {
//                             // Timestamp - 1655218800000
//                             var dateUTC = response[i]['fixture']['date'] != null ? Date.parse(response[i]['fixture']['date']) : null;
                            
//                             // Date obj - 2022-05-30 04:54:19.172481Z
//                             var dateUTCobj = new Date(dateUTC);

//                             // Timestamp - 1655218800000 + 8 hours
//                             var dateOffset = dateUTCobj.setHours(dateUTCobj.getHours() + offset);
                            
//                             // Date obj - 2022-05-30 04:54:19.172481Z + 8 hours
//                             var date = new Date(dateOffset);
                            
                            
//                             var dateFormatString = date.toLocaleDateString('af-ZA', optionsFormat); // 2022-05-30
//                             var dateRemoveDash = dateFormatString.replaceAll('-', '');
//                             var dayString = days[date.getDay()]; // getDay() = 0-6 = Sunday-Saturday
//                             var date2 = dateRemoveDash + dayString; // 20220613Monday

//                             var leagueName = response[i]['league']['name'] != null && response[i]['league']['country'] != null ? getPiala(response[i]['league']['name'], response[i]['league']['country']) : null;
                            
//                             var hour = padLeft(date.getHours()); // Create function below
//                             var minute = padLeft(date.getMinutes()); // Create function below
//                             var time = hour + ":" + minute;

//                             var fixtureId = response[i]['fixture']['id'];

//                             var team1 = getTeamName(response[i]['teams']['home']['name']);
//                             var team2 = getTeamName(response[i]['teams']['away']['name']);
                            
//                             var skor1 = response[i]['goals']['home'] ?? 0;
//                             var skor2 = response[i]['goals']['away'] ?? 0;

//                             var logoLeagueCustomPath = 'assets/piala/' + leagueName + '.png';
//                             var team1Path = 'assets/team/' + getTeamName(response[i]['teams']['home']['name'], 'team') + '.png';
//                             var team2Path = 'assets/team/' + getTeamName(response[i]['teams']['away']['name'], 'team') + '.png';
//                             let [leagueLogoCustom, team1URL, team2URL] = await Promise.all([
//                                 getDownloadURL(logoLeagueCustomPath),
//                                 getDownloadURL(team1Path),
//                                 getDownloadURL(team2Path)
//                             ]);

//                             var path1 = 'Fixtures/' + date.getFullYear().toString() +'/'+date2+'/'+response[i]['league']['id'];
//                             admin.database().ref(path1).update({
//                                 'id' : response[i]['league']['id'],
//                                 'season' : response[i]['league']['season'],
//                                 'date' : dateRemoveDash,
//                                 'name' : leagueName,
//                                 'country' : response[i]['league']['country'],
//                                 'flag' : response[i]['league']['flag'],
//                                 'logoLeague' : response[i]['league']['logo'],
//                                 'logoLeagueCustom' : leagueLogoCustom
//                             });

//                             var path2 = 'Fixtures/' + date.getFullYear().toString() +'/'+date2+'/'+response[i]['league']['id']+'/time/'+time+'/'+fixtureId.toString();
//                             admin.database().ref(path2).set({
//                                 'fixture' : {
//                                     'id' : fixtureId,
//                                     'datetime' : response[i]['fixture']['date'],
//                                     'date': dateRemoveDash,
//                                     'day': dayString,
//                                     'time': time,
//                                     'referee' : response[i]['fixture']['referee'],
//                                     'round' : response[i]['league']['round'],
//                                     'statuslong' : response[i]['fixture']['status']['long'],
//                                     'statusshort' : response[i]['fixture']['status']['short'],
//                                     'venue' : {
//                                         'id' : response[i]['fixture']['venue']['id'],
//                                         'city' : response[i]['fixture']['venue']['city'],
//                                         'name' : response[i]['fixture']['venue']['name']
//                                     }
//                                 },
//                                 'league' : {
//                                     'id' : response[i]['league']['id'],
//                                     'country' : response[i]['league']['country'],
//                                     'flag' : response[i]['league']['flag'],
//                                     'logo' : response[i]['league']['logo'],
//                                     'logocustom' : leagueLogoCustom,
//                                     'name' : leagueName,
//                                     'season' : response[i]['league']['season']
//                                 },
//                                 'teams' : {
//                                     'home' : {
//                                         'id' : response[i]['teams']['home']['id'],
//                                         'logo' : response[i]['teams']['home']['logo'],
//                                         'logocustom' : team1URL,
//                                         'name' : team1,
//                                         'winner' : response[i]['teams']['home']['winner']
//                                     },
//                                     'away' : {
//                                         'id' : response[i]['teams']['away']['id'],
//                                         'logo' : response[i]['teams']['away']['logo'],
//                                         'logocustom' : team2URL,
//                                         'name' : team2,
//                                         'winner' : response[i]['teams']['away']['winner']
//                                     }
//                                 },
//                                 'goals' : {
//                                     'home' : skor1,
//                                     'away' : skor2
//                                 },
//                                 'score' : {
//                                     'halftime' : {
//                                         'home' : response[i]['score']['halftime']['home'],
//                                         'away' : response[i]['score']['halftime']['away']
//                                     },
//                                     'fulltime' : {
//                                         'home' : response[i]['score']['fulltime']['home'],
//                                         'away' : response[i]['score']['fulltime']['away']
//                                     },
//                                     'extratime' : {
//                                         'home' : response[i]['score']['extratime']['home'],
//                                         'away' : response[i]['score']['extratime']['away']
//                                     },
//                                     'penalty' : {
//                                         'home' : response[i]['score']['penalty']['home'],
//                                         'away' : response[i]['score']['penalty']['away']
//                                     }
//                                 }
//                             });

//                             //console.log("Match Added. (" + fixtureId + ") (" + dateUTCobj.toISOString() +")");

//                             try {
//                                 // Remove Duplicate Match (SAME DAY)
//                                 var path3 = 'Fixtures/' + date.getFullYear().toString() +'/'+date2+'/'+response[i]['league']['id']+'/time';
//                                 admin.database().ref(path3).once('value').then((snapshot) => {
//                                     if (snapshot.exists()) {
//                                         snapshot.forEach((dataTime) => {
//                                             dataTime.forEach((dataMatch) => {
//                                                 if (dataMatch.key == fixtureId.toString()) {
//                                                     if (dataTime.key != time.toString()) {
//                                                         console.log('Same Day Duplicate Removed: ' + dateRemoveDash + ' Old('+dataTime.key+'), New(' + date.toISOString() + ') | ' + dataMatch.key);
//                                                         var pathRemoveDupl = path3 + '/' + dataTime.key + '/' + dataMatch.key;
//                                                         admin.database().ref(pathRemoveDupl).set({});
//                                                     }
//                                                 }
//                                             });
//                                         });
//                                     }
//                                 });
//                             } catch (e) {
//                                 console.log('ERROR SAME DAY REMOVE DUPLICATE MATCH: ' + e);
//                             }

//                             try {
//                                 // Remove Duplicate Match (WHOLE YEAR)
//                                 if (dataThisYear != null) {
//                                     dataThisYear.forEach((dataDate) => {
//                                         if (dataDate.key != date2) {
//                                             dataDate.forEach((dataLeague) => {
//                                                 if (dataLeague.val()['time'] != null) {
//                                                     dataLeague.child('time').forEach((dataTime) => {
//                                                         dataTime.forEach((dataMatch) => {
//                                                             if (dataMatch.key == fixtureId.toString()) {
//                                                                 console.log('Duplicate Match Removed: ' + dataDate.key + ' | ' + dataMatch.key);
//                                                                 var pathRemoveDupl2 = 'Fixtures/' + date.getFullYear().toString() +'/'+dataDate.key+'/'+response[i]['league']['id']+'/time/'+dataTime.key+'/'+dataMatch.key;
//                                                                 admin.database().ref(pathRemoveDupl2).set({});
//                                                             }
//                                                         });
//                                                     });

//                                                 }
//                                             });
//                                         }
//                                     });
//                                 }
//                             } catch (e) {
//                                 console.log('ERROR WHOLE YEAR REMOVE DUPLICATE MATCH: ' + e);
//                             }
//                         } catch (e) {console.log("ROSAK : " + e);}
                        
//                     }

//                 });
                
//             });
//         }
//     } catch (e) {
//         console.log("KEROASAKAN : " + e);
//     }

//     return null;

    
// });

// function padLeft(n){return n<10 ? '0'+n : n.toString();}

// function getTeamName(name) {
//   if (name == "Johor Darul Takzim FC")
//     return "Johor Darul Ta'zim";
//   else if (name == "Kuala Lumpur FA")
//     return "Kuala Lumpur City";
//   else if (name == "UiTM FC")
//     return "UiTM";
//   else if (name == "Sabah FA")
//     return "Sabah";
//   else if (name == "Pahang")
//     return "Sri Pahang";
//   else if (name == "Kedah")
//     return "Kedah Darul Aman";
//   else if (name == "Kuching FA")
//     return "Kuching City";
//   else if (name == "Skuad Projek")
//     return "Projek FAM-MSN";
//   else if (name == "Terengganu City II")
//     return "Terengganu II";
//   else if (name == "Pknp")
//     return "Perak II";
//   else if (name == "Pdrm")
//     return "PDRM";
//   else if (name == "Johor Darul Tazim II")
//     return "Johor Darul Ta'zim II";
//   else if (name == "Kelantan FA")
//     return "Kelantan";
//   else if (name == "Selangor United")
//     return "Sarawak United";
//   else 
//     return name;
// }

// function getPiala(piala, country) {
//   if (piala == "AFC Champions League")
//     return "lAFC Champions League";
//   else if (piala == "AFC Cup")
//     return "mAFC Cup";

//   // Malaysia
//   else if (piala == "Super League" && country == "Malaysia")
//     return "hLiga Super";
//   else if (piala == "Premier League" && country == "Malaysia")
//     return "iLiga Premier";
//   else if (piala == "Malaysia Cup")
//     return "kPiala Malaysia";
//   else if (piala == "FA Cup" && country == "Malaysia")
//     return "jPiala FA";

//   // World
//   else if (piala == "World Cup")
//     return "gPiala Dunia";
//   else if (piala == "Olympics Men")
//     return "dOlimpik";
//   else if (piala == "Friendlies")
//     return "vFriendly";
//   else if (piala == "Friendlies Clubs")
//     return "wClub Friendly";
//   else if (piala == "World Cup - Qualification Asia")
//     return "rPiala Dunia - Kelayakan Asia";
//   else if (piala == "World Cup - U20")
//     return "sPiala Dunia U20";
//   else if (piala == "World Cup - U17")
//     return "tPiala Dunia U17";

//   // SEA
//   else if (piala == "AFF Championship")
//     return "fAFF Suzuki Cup";
//   else if (piala == "Southeast Asian Games")
//     return "eSEA Games";
//   else if (piala == "AFF U23 Championship")
//     return "xAFF U23 Championship";
  
//   // ASIA
//   else if (piala == "Asian Cup")
//     return "pAsian Cup";
//   else if (piala == "Asian Games")
//     return "cAsian Games";
//   else if (piala == "Asian Cup - Qualification")
//     return "qAsian Cup - Kelayakan";
//   else if (piala == "AFC U23 Championship")
//     return "uAFC U23 Championship";
  

//   else
//     return piala;
// }

// // Get storage URL
// async function getDownloadURL(path) {
//     try {
//         const file =  admin.storage().bucket(`gs://${bucket}`).file(path);
//         const [metadata] = await file.getMetadata();

//         const token = metadata.metadata.firebaseStorageDownloadTokens;
//         const url = 'https://firebasestorage.googleapis.com/v0/b/'+bucket+'/o/'
//                         + encodeURIComponent(path) + '?alt=media&token=' + token;
//         return url;
//     } catch (_) {
//         return null;
//     }
// }