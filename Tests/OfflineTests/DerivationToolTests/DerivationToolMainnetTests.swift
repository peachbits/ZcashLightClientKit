//
//  DerivationToolTests.swift
//  ZcashLightClientKit-Unit-Tests
//
//  Created by Francisco Gindre on 10/9/20.
//
//swiftlint:disable force_unwrapping
import XCTest
@testable import ZcashLightClientKit

class DerivationToolMainnetTests: XCTestCase {
    var seedPhrase = "still champion voice habit trend flight survey between bitter process artefact blind carbon truly provide dizzy crush flush breeze blouse charge solid fish spread" //TODO: Parameterize this from environment?
    var seedData: Data = Data(base64Encoded: "9VDVOZZZOWWHpZtq1Ebridp3Qeux5C+HwiRR0g7Oi7HgnMs8Gfln83+/Q1NnvClcaSwM4ADFL1uZHxypEWlWXg==")!
    let testRecipientAddress = UnifiedAddress(validatedEncoding: "u1l9f0l4348negsncgr9pxd9d3qaxagmqv3lnexcplmufpq7muffvfaue6ksevfvd7wrz7xrvn95rc5zjtn7ugkmgh5rnxswmcj30y0pw52pn0zjvy38rn2esfgve64rj5pcmazxgpyuj") //TODO: Parameterize this from environment
    
    let expectedSpendingKey = SaplingExtendedSpendingKey(validatedEncoding: "secret-extended-key-main1qw28psv0qqqqpqr2ru0kss5equx6h0xjsuk5299xrsgdqnhe0cknkl8uqff34prwkyuegyhh5d4rdr8025nl7e0hm8r2txx3fuea5mquy3wnsr9tlajsg4wwvw0xcfk8357k4h850rgj72kt4rx3fjdz99zs9f4neda35cq8tn3848yyvlg4w38gx75cyv9jdpve77x9eq6rtl6d9qyh8det4edevlnc70tg5kse670x50764gzhy60dta0yv3wsd4fsuaz686lgszc7nc9vv")
    
    let expectedViewingKey = UnifiedFullViewingKey(validatedEncoding: "uview17fme6ux853km45g9ep07djpfzeydxxgm22xpmr7arzxyutlusalgpqlx7suga4ahzywfuwz4jclm00u7g8u65qvvdt45kttnfunvschssg3h3g06txs9ja32vx3xa8dej3unnatgzjvd0vumk37t8es3ludldrtse3q6226ws7eq4q0ywz78nudwpepgdn7jmxz8yvp7k6gxkeynkam0f8aqf9qpeaej55zhkw39x7epayhndul0j4xjttdxxlnwcd09nr8svyx8j0zng0w6scx3m5unpkaqxcm3hslhlfg4caz7r8d4xy9wm7klkg79w7j0uyzec5s3yje20eg946r6rmkf532nfydu26s8q9ua7mwxw2j2ag7hfcuu652gw6uta03vlm05zju3a9rwc4h367kqzfqrcz35pdwdk2a7yqnk850un3ujxcvve45ueajgvtr6dj4ufszgqwdy0aedgmkalx2p7qed2suarwkr35dl0c8dnqp3", account: 0)
    let expectedSaplingExtendedViewingKey = SaplingExtendedFullViewingKey(validatedEncoding: "zxviews1qw28psv0qqqqpqr2ru0kss5equx6h0xjsuk5299xrsgdqnhe0cknkl8uqff34prwkysswfhjk79n8l99f2grd26dqg6dy3jcmxsaypxfsu6ara6vsk3x8l544uaksstx9zre879mdg7s9a7zurrx6pf5qg2n323js2s3zlu8tn3848yyvlg4w38gx75cyv9jdpve77x9eq6rtl6d9qyh8det4edevlnc70tg5kse670x50764gzhy60dta0yv3wsd4fsuaz686lgszcq7kwxy")

    let expectedSaplingAddress = SaplingAddress(validatedEncoding: "zs1vp7kvlqr4n9gpehztr76lcn6skkss9p8keqs3nv8avkdtjrcctrvmk9a7u494kluv756jeee5k0")
    
    let derivationTool = DerivationTool(networkType: NetworkType.mainnet)
    let expectedTransparentAddress = TransparentAddress(validatedEncoding: "t1dRJRY7GmyeykJnMH38mdQoaZtFhn1QmGz")
    func testDeriveViewingKeysFromSeed() throws {
        let accounts: Int = 1
        let seedBytes = [UInt8](seedData)
        let viewingKeys = try derivationTool.deriveUnifiedFullViewingKeys(seed: seedBytes, numberOfAccounts: accounts)

        XCTAssertEqual(viewingKeys.count, accounts, "the number of viewing keys have to match the number of account requested to derive")

        guard let viewingKey = viewingKeys.first else {
            XCTFail("no viewing key generated")
            return
        }
        XCTAssertEqual(expectedViewingKey, viewingKey)
        
    }
    
    func testDeriveViewingKeyFromSpendingKeys() throws {
        XCTAssertEqual(expectedSaplingExtendedViewingKey, try derivationTool.deriveViewingKey(spendingKey: expectedSpendingKey))
    }
    
    func testDeriveSpendingKeysFromSeed() throws {
        let accounts: Int = 1
        let seedBytes = [UInt8](seedData)
        
        let spendingKeys = try derivationTool.deriveSpendingKeys(seed: seedBytes, numberOfAccounts: accounts)
        XCTAssertEqual(spendingKeys.count, accounts, "the number of viewing keys have to match the number of account requested to derive")
        
        guard let spendingKey = spendingKeys.first else {
            XCTFail("no viewing key generated")
            return
        }
        XCTAssertEqual(expectedSpendingKey, spendingKey)

    }
    
    func testDeriveUnifiedAddressFromSeed() throws {
        let seedBytes = [UInt8](seedData)
        
        let unifiedAddress = try derivationTool.deriveUnifiedAddress(seed: seedBytes, accountIndex: 0)
        XCTAssertEqual(unifiedAddress, testRecipientAddress)
    }
    
    func testDeriveUnifiedAddressFromViewingKey() throws {
        XCTAssertEqual(try derivationTool.deriveUnifiedAddress(from: expectedViewingKey), testRecipientAddress)
    }
    
    func testDeriveTransparentAddressFromSeed() throws {
        XCTAssertEqual(try derivationTool.deriveTransparentAddress(seed: [UInt8](seedData)), expectedTransparentAddress)
    }
    
    func testIsValidViewingKey() throws {
        XCTAssertTrue(try derivationTool.isValidExtendedViewingKey("zxviews1q0dm7hkzqqqqpqplzv3f50rl4vay8uy5zg9e92f62lqg6gzu63rljety32xy5tcyenzuu3n386ws772nm6tp4sads8n37gff6nxmyz8dn9keehmapk0spc6pzx5uxepgu52xnwzxxnuja5tv465t9asppnj3eqncu3s7g3gzg5x8ss4ypkw08xwwyj7ky5skvnd9ldwj2u8fz2ry94s5q8p9lyp3j96yckudmp087d2jr2rnfuvjp7f56v78vpe658vljjddj7s645q399jd7"))
        
        XCTAssertFalse(try derivationTool.isValidExtendedViewingKey("zxviews1q0dm7hkzky5skvnd9ldwj2u8fz2ry94s5q8p9lyp3j96yckudmp087d2jr2rnfuvjp7f56v78vpe658vljjddj7s645q399jd7"))
    }
    
    func testDeriveTransparentAccountPrivateKeyFromSeed() throws {
        XCTAssertEqual(try derivationTool.deriveTransparentAccountPrivateKey(seed: [UInt8](seedData)), TransparentAccountPrivKey(encoding: "xprv9yCTU6giJ1qZ1DLC5rc7KMzwY9s8rSRXYqmoAKffAExpUVUKLhcdvN9ERdxjEW8tQq4pxerLKZE3WcNUKZCeX19rVTxpV2msTyNMNiFT3Nw"))
    }
    
    func testDeriveUnifiedKeysFromSeed() throws {
        let unifiedKeys = try derivationTool.deriveUnifiedFullViewingKeysFromSeed([UInt8](seedData), numberOfAccounts: 1)
        XCTAssertEqual(unifiedKeys.count, 1)
        
        XCTAssertEqual(unifiedKeys[0].account, 0)
        XCTAssertEqual(unifiedKeys[0], expectedViewingKey)
    }
    
    func testDeriveQuiteALotOfUnifiedKeysFromSeed() throws {
        let unifiedKeys = try derivationTool.deriveUnifiedFullViewingKeysFromSeed([UInt8](seedData), numberOfAccounts: 10)
        XCTAssertEqual(unifiedKeys.count, 10)
        
        XCTAssertEqual(unifiedKeys[0].account, 0)
        XCTAssertEqual(unifiedKeys[0], expectedViewingKey)
    }
    
    func testShouldFailOnInvalidChecksumAddresses() throws {
        let testAddress = "t14oHp2v54vfmdgQ3v3SNuQga8JKHTNi2a1"
        XCTAssertFalse(try derivationTool.isValidTransparentAddress(testAddress))
    }

    func testSpendingKeyValidation() throws {
        XCTAssertTrue(try derivationTool.isValidSaplingExtendedSpendingKey(expectedSpendingKey.stringEncoded))
    }

    func testSpendingKeyValidationFailsOnInvalidKey() throws {
        let wrongSpendingKey = "secret-extended-key-main1qw28psv0qqqqpqr2ru0kss5equx6h0xjsuk5299xrsgdqnhe0cknkl8uqff34prwkyuegyhh5d4rdr8025nl7e0hm8r2txx3fuea5mquy3wnsr9tlajsg4wwvw0xcfk8357k4h850rgj72kt4rx3fjdz99zs9f4neda35cq8tn3848yyvlg4w38gx75cyv9jdpve77x9eq6rtl6d9qyh8det4edevlnc70tg5kse670x50764gzhy60dta0yv3wsd4fsuaz686lgszc7nc9vvZzZzZz"

        XCTAssertFalse(try derivationTool.isValidSaplingExtendedSpendingKey(wrongSpendingKey))
    }
    // TODO: Address encoding does not catch this test https://github.com/zcash/ZcashLightClientKit/issues/509
//    func testSpendingKeyValidationThrowsWhenWrongNetwork() throws {
//        XCTAssertThrowsError(try derivationTool.isValidExtendedSpendingKey("secret-extended-key-test1qdxykmuaqqqqpqqg3x5c02p4rhw0rtszr8ln4xl7g6wg6qzsqgn445qsu3cq4vd6lk8xce3d4jw7s8ln5yjp6fqv2g0nzue2hc0kv5t004vklvlenncscq9flwh5vf5qnv0hnync72n7gjn70u47765v3kyrxytx50g730svvmhhlazn5rj8mshh470fkrmzg4xarhrqlygg8f486307ujhndwhsw2h7ddzf89k3534aeu0ypz2tjgrzlcqtat380vhe8awm03f58cqe49swv"))
//    }
}
