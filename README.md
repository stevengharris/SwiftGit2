# SwiftGit2

Please see [SwiftGit2](https://github.com/SwiftGit2/SwiftGit2) that this repo was forked-from for the original README.

## Mac Catalyst Changes

I made the following changes to [SwiftGit2](https://github.com/SwiftGit2/SwiftGit2) to update the underlying library versions it consumes and to accommodate Mac Catalyst.

1. Updated OpenSSL version from 1.0.2p to 1.1.1d. This was done by pulling in [OpenSSL-for-iPhone](https://github.com/x2on/OpenSSL-for-iPhone) as a submodule in /External, simlarly to the way the original used [OpenSSL](https://github.com/openssl/openssl).

   Uses new update_libssl_111_ios and update_libssl_111_catalyst scripts.  If I could have made the original SwiftGit2 script, update_libssl_ios, work with the newer OpenSSL version, I might have done all this work in a way that would make for a nice pull request. However, I wasted too much time tryign to get that to happen and finally decided just to use OpenSSL-for-iPhone.
   
2. Updated [libssh2](https://github.com/libssh2/libssh2) version from 1.8.0 to 1.9.0.

   Uses new update_libssh2_190_ios and update_libssh2_190_catalyst scripts
   
3. Updated [libgit2](https://github.com/libgit2/libgit2) version from 0.27.7 to 1.0.1.

   Uses new update_libgit2_101_ios and update_libgit2_101_catalyst scripts
   
4. Added new Xcode targets:

   OpenSSL_111-iOS - Produce iOS versions libcrypto.a and ssl.a as a fat library in External/libgit2-1.0.1-ios
   
   OpenSSL_111-Catalyst - Produce Mac Catalyst versions libcrypto.a and ssl.a as a fat library in External/libgit2-1.0.1-catalyst
   
   libssh2_190-iOS - Produce iOS version of libssh2 as a fat library in libssh2-1.9.0-ios
   
   libssh2_190-Catalyst - Produce Mac Catalyst version of libssh2 as a fat library in libssh2-1.9.0-catalyst
   
   libgit2_101-iOS - Produce iOS version of libgit2 as a fat library in libgit2-1.0.1-ios
   
   libgit2_101-Catalyst - Produce Mac Catalyst version of libgit2 as a fat library in libgit2-1.0.1-catalyst
   
   SwiftGit2_101-iOS - Produce an iOS framework, SwiftGit2.framework like the [SwiftGit2](https://github.com/SwiftGit2/SwiftGit2), but for updated openssl, libssh2, and libgit.
   
   SwiftGit2_101-Catalyst - Produce a Mac Catalyst framework, SwiftGit2_Catalyst.framework like the [SwiftGit2](https://github.com/SwiftGit2/SwiftGit2), but for updated openssl, libssh2, and libgit.

Note that the underlying scripts build arm64 and x86_64 for the iPhone and simulator, and x86_64 for Mac Catalyst, regardless of build settings.

To keep the original SwiftGit2 targets working, I added a -D LIBGIT2V1 flag to the build settings. There were some changes needed in the .swift code to handle the move to libgit2 v1.0.1. These are handled conditionally; e.g., in Repository.swift you will see:

```
#if LIBGIT2V1
 <new code>
#else
 <old code>
#endif
```

Unfortunately, I didn't sort out how to combine things in a .xcframework. You can consume the separately named frameworks in your Swift project by adding them both (which is all a .xcframework would do anyway). However, you need to do the includes in your Swift code conditionally; e.g.,

```
#if targetEnvironment(macCatalyst)
import SwiftGit2_Catalyst
#else
import SwiftGit2
#endif
```

## License
These changes to SwiftGit2 are available under the MIT license, like the original.
