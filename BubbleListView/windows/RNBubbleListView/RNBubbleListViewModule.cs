using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Bubble.List.View.RNBubbleListView
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNBubbleListViewModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNBubbleListViewModule"/>.
        /// </summary>
        internal RNBubbleListViewModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNBubbleListView";
            }
        }
    }
}
