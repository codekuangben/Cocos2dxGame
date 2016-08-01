<GameFile>
  <PropertyGroup Name="UITest" Type="Layer" ID="4c13e9f3-7041-4f52-b28f-661b30ff604a" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="21" Speed="1.0000" ActivedAnimationName="Ani_Btn">
        <Timeline ActionTag="1834039357" Property="Position">
          <PointFrame FrameIndex="5" X="889.0001" Y="164.9999">
            <EasingData Type="-1">
              <Points>
                <PointF />
                <PointF Y="0.4800" />
                <PointF X="0.9500" Y="0.1700" />
                <PointF X="1.0000" Y="1.0000" />
              </Points>
            </EasingData>
          </PointFrame>
          <PointFrame FrameIndex="13" X="889.0001" Y="164.9999">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="21" X="889.0001" Y="164.9999">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="1834039357" Property="Scale">
          <ScaleFrame FrameIndex="5" X="1.0000" Y="1.0000">
            <EasingData Type="-1">
              <Points>
                <PointF />
                <PointF Y="0.4800" />
                <PointF X="0.9500" Y="0.1700" />
                <PointF X="1.0000" Y="1.0000" />
              </Points>
            </EasingData>
          </ScaleFrame>
          <ScaleFrame FrameIndex="13" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="21" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="1834039357" Property="RotationSkew">
          <ScaleFrame FrameIndex="5" X="0.0000" Y="0.0000">
            <EasingData Type="-1">
              <Points>
                <PointF />
                <PointF Y="0.4800" />
                <PointF X="0.9500" Y="0.1700" />
                <PointF X="1.0000" Y="1.0000" />
              </Points>
            </EasingData>
          </ScaleFrame>
          <ScaleFrame FrameIndex="13" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="21" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-851448609" Property="Position">
          <PointFrame FrameIndex="11" X="617.0000" Y="375.0000">
            <EasingData Type="0" />
          </PointFrame>
          <PointFrame FrameIndex="21" X="658.0000" Y="191.0000">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="Ani_Btn" StartIndex="0" EndIndex="30">
          <RenderColor A="255" R="255" G="255" B="224" />
        </AnimationInfo>
        <AnimationInfo Name="Ani_Image" StartIndex="0" EndIndex="30">
          <RenderColor A="255" R="0" G="255" B="127" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Layer" Tag="6" ctype="GameLayerObjectData">
        <Size X="960.0000" Y="640.0000" />
        <Children>
          <AbstractNodeData Name="Button_1" ActionTag="1834039357" Tag="7" IconVisible="False" LeftMargin="866.0001" RightMargin="47.9999" TopMargin="457.0001" BottomMargin="146.9999" TouchEnable="True" FontSize="14" ButtonText="Button" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="16" Scale9Height="14" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="46.0000" Y="36.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="889.0001" Y="164.9999" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.9260" Y="0.2578" />
            <PreSize X="0.0479" Y="0.0562" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
            <PressedFileData Type="Default" Path="Default/Button_Press.png" Plist="" />
            <NormalFileData Type="Default" Path="Default/Button_Normal.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="CheckBox_1" ActionTag="-851448609" Tag="8" IconVisible="False" LeftMargin="625.7000" RightMargin="294.3000" TopMargin="373.8000" BottomMargin="226.2000" TouchEnable="True" CheckedState="True" ctype="CheckBoxObjectData">
            <Size X="40.0000" Y="40.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="645.7000" Y="246.2000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.6726" Y="0.3847" />
            <PreSize X="0.0417" Y="0.0625" />
            <NormalBackFileData Type="Default" Path="Default/CheckBox_Normal.png" Plist="" />
            <PressedBackFileData Type="Default" Path="Default/CheckBox_Press.png" Plist="" />
            <DisableBackFileData Type="Default" Path="Default/CheckBox_Disable.png" Plist="" />
            <NodeNormalFileData Type="Default" Path="Default/CheckBoxNode_Normal.png" Plist="" />
            <NodeDisableFileData Type="Default" Path="Default/CheckBoxNode_Disable.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="Text_1" ActionTag="1093448636" Tag="10" IconVisible="False" LeftMargin="236.0000" RightMargin="624.0000" TopMargin="425.0000" BottomMargin="195.0000" FontSize="20" LabelText="Text Label" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
            <Size X="100.0000" Y="20.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="286.0000" Y="205.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.2979" Y="0.3203" />
            <PreSize X="0.1042" Y="0.0313" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>